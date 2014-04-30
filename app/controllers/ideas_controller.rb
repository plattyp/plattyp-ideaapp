class IdeasController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_user, :get_group

  def index
    # Looks at the user's id and shows all ideas that belong to that user
    @ideas = @user.ideas.all
  end


  def show
    #Looks to see if the user's group has access to an idea & redirects if they dont
    if @user.ideas.find_by_id(params[:id])
      @idea = @user.ideas.find(params[:id])
    else
      redirect_to ideas_path, :notice => "That idea doesn't exist!"
    end
  end

  def new
  	@idea = Idea.new
    @ideatype_options = Ideatype.where('active = true').all.map {|i| [i.name, i.id]}
  end

  def create
    @idea = @user.ideas.build(idea_params)
    @idea.ideausers.build(:user => @user, :is_admin => true)
  	if @idea.save
        redirect_to ideas_path, :notice =>"The idea was saved!"
  	else
      render :action => "new"
  	end
  end

  def edit
    #Looks to see if the user's group has access to an idea & redirects if they don't
    if @user.ideas.find_by_id(params[:id])
      @idea = @user.ideas.find(params[:id])
      @ideatype_options = Ideatype.where('active = true').all.map {|i| [i.name, i.id]}
    else
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end
  end

  def update
    #Looks to see if the user's group has access to an idea & redirects if they don't
    if @user.ideas.find_by_id(params[:id])
      @idea = @user.ideas.find(params[:id])
    else
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end

  	if @idea.update_attributes(idea_params)
  		redirect_to edit_idea_path(@idea, :anchor => 'idea'), :notice =>"The idea is updated!"
  	else
      render :action => "edit"
  	end

  end

  def destroy
    #Looks to see if the user's group has access to an idea & redirects if they don't
    if @user.ideas.find_by_id(params[:id])
      @idea = @user.ideas.find(params[:id])
    else
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end
    
  	@idea.destroy
  	redirect_to ideas_path, :notice => "Your idea was deleted!"
  end

  private

  def idea_params
    params.require(:idea).permit(:name, :description, :ideatype_id, :ideausers_attributes => [:is_admin])
  end

  def get_user
    @user = current_user
  end

  def get_group
    @group = @user.group
  end

end
