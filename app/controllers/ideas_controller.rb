class IdeasController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_user, :get_group, :group_users, :check_user_status
  before_action :check_user_access, :if => @idea, :only => [:show, :edit, :update]

  def index
    # Looks at the user's id and shows all ideas that belong to that user
    @ideas = Idea.returnideas(params[:ideatypes],@user.id,params[:searchstring])
    @ideatypes = Idea.returndistinctideatypes(@user.id)

    # Lookup the Creator/Admin for the idea and add to an array
    @ideasarray = Array.new
    @ideas.each do |i|
      # Lookup the admin for the idea
      creator = Ideauser.return_admin(i.id).first
      unreadmessagecount = Notification.return_notificationcount(@user.id,"Ideamessage",i.id)
      @ideasarray << [i.id,i.name,i.description,i.ideatypename,creator.username,unreadmessagecount]
    end

    # Returns the selected list of ideatypes
    @selectedideatypes = params[:ideatypes]
    @ideatypelist = []

    # Set the Search String parameter to be used by the view
    @searchstring = params[:searchstring]

    # Iterate through the ideatypes to set which are already set
    @ideatypes.each do |i|
      if @selectedideatypes.blank?
        selected = true
      else
        if @selectedideatypes.include?(i.to_s)
          selected = true
        else
          selected = false
        end
      end
      @ideatypelist << [i,selected]
    end
  end

  def show
    #Security is handled using before_action and check_user_access controller
    @idea = @user.ideas.find(params[:id])
  end

  def new
    @stepno = 1
  	@idea = Idea.new
    @ideatype_options = Ideatype.returnideatypes(@group.id)
  end

  def create
    @idea = @user.ideas.build(idea_params)
    @idea.ideausers.build(:user => @user, :is_admin => true, :role => "Super Admin")
  	if @idea.save
        #Create initial subfeature categories for the idea
        onboard(@idea.id)

        #Get all invited users so that they can be added accordingly
        @recentlyinvited = Inviteduser.return_unprocessed(@idea.id)

        #Iterate through to the users that have not been processed
        @recentlyinvited.each do |i|
          invite_user(i)
        end

        #Redirect back to the index
        redirect_to ideas_path, :notice =>"The idea was saved!"
  	else
      @ideatype_options = Ideatype.returnideatypes(@group.id)
      render :action => "new"
  	end
  end

  def edit
    #Security is handled using before_action and check_user_access controller
    @idea = @user.ideas.find(params[:id])
    @ideatype_options = Ideatype.returnideatypes(@group.id)

    #Return unread messages count
    @unread_message_count = notification_count("Ideamessage")
  end

  def update
    #Security is handled using before_action and check_user_access controller
  	if @idea.update_attributes(idea_params)
  		  redirect_to edit_idea_path(@idea, :anchor => 'idea'), :notice =>"The idea is updated!"
  	else
      render :action => "edit"
  	end

  end

  def destroy
    #Security is handled using before_action and check_user_access controller
    @idea = @user.ideas.find(params[:id])
  	@idea.destroy
  	redirect_to ideas_path, :notice => "Your idea was deleted!"
  end

  def onboard(idea_id)
    #Gets defult values from Settings table for given group
    @initialcategories = Setting.retrieve_groupvalues(@group.id,"Subfeature Category")

    #Loops through array and create's a category for each value for the given idea
    @initialcategories.each do |i|
      Subfeaturecategory.create(:categoryname => i.value,:idea_id => idea_id)
    end
  end

  def next_step
    if params[:direction] === 'forward'
      @stepno = params[:stepno].to_i + 1
    else
      @stepno = params[:stepno].to_i - 1
    end

    respond_to do |format|
      format.js
    end
  end

  def invite_user(invited)
    @inviteduser = invited
    role = "Participant"
    @inviteduser.role = role

    #Checks to see if a matching user already exists in the system
    @matcheduser = User.search_users(@inviteduser.emailaddress)

    #Checks to see if an invite was already sent for this user
    @invitedusercheck = Inviteduser.search_invited(@inviteduser.emailaddress, @idea.id).first

    #If he has not been invited, an entry will be made in InvitedUsers table
    if @invitedusercheck.nil?
      if @inviteduser.save
        #Checks to see if a current user with that email exists
        if @matcheduser.count === 0
          #If he doesn't exist, an email is sent to the user
          InviteduserMailer.invited_email(@inviteduser.emailaddress).deliver
          return true, "An email was sent to invite the user!"
        else
          #If user already is a member of the site, it will add him to the workroom
          @matcheduser.each do |user|
            Ideauser.create(:user_id => user.id, :idea_id => @idea.id, :role => role)
            InviteduserMailer.addedtoidea_email(user.email, @idea).deliver
            return true, "The user was added to the workroom successfully!"
          end
        end
      else
        return false, "Sorry, but the user could not be added."
      end
    else
      #If the user's role field is empty, it implies that he has been invited but not processed.
      if @invitedusercheck.role.nil?
        if @matcheduser.count === 0
          #If he doesn't exist, an email is sent to the user
          InviteduserMailer.invited_email(@invitedusercheck.emailaddress).deliver
        else
          #If user already is a member of the site, it will add him to the workroom and send an email
          @matcheduser.each do |user|
            Ideauser.create(:user_id => user.id, :idea_id => @idea.id, :role => role)
            InviteduserMailer.addedtoidea_email(user.email, @idea).deliver
          end
        end
        @invitedusercheck.update_attributes(:role => role)
        return true, "The user was added to the workroom successfully!"
      else
        return false, "The user has already been invited!"
      end
    end
  end

  private

  def idea_params
    params.require(:idea).permit(:name, :description, :ideatype_id, ideausers_attributes: [:idea_id, :user_id, :role], features_attributes: [:id, :name, :description, :idea_id, :user_id, :_destroy], invitedusers_attributes: [:id, :emailaddress, :idea_id, :invited_by_user_id, :role, :_destroy])
  end

  def get_user
    @user = current_user
  end

  def get_group
    @group = @user.group
  end

  def group_users
    @users = User.all.map {|i| [i.username, i.id]}
  end

  def get_idea
    @idea = Idea.find_by_id(params[:id])
  end

  def check_user_access
    unless @user.ideas.find_by_id(params[:id])
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end
  end

  def notification_count(type)
    Notification.return_notificationcount(@user.id,type,@idea.id)
  end

end
