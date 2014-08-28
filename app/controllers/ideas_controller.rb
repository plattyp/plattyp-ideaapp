class IdeasController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_user, :get_group, :group_users, :check_user_status
  before_action :check_user_access, :if => @idea, :only => [:show, :edit, :update]

  def index
    # Looks at the user's id and shows all ideas that belong to that user
    @ideas = Idea.returnideas(params[:ideatypes],@user.id,params[:searchstring])
    @ideatypes = Idea.returndistinctideatypes(@user.id)

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
  	@idea = Idea.new
    @ideatype_options = Ideatype.returnideatypes(@group.id)
  end

  def create
    @idea = @user.ideas.build(idea_params)
    @idea.ideausers.build(:user => @user, :is_admin => true, :role => "Super Admin")
  	if @idea.save
        #Create initial subfeature categories for the idea
        onboard(@idea.id)

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

  private

  def idea_params
    params.require(:idea).permit(:name, :description, :ideatype_id, ideausers_attributes: [:idea_id, :user_id], features_attributes: [:id, :name, :description, :idea_id, :user_id, :_destroy])
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

end
