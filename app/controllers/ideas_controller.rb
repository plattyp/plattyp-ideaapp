class IdeasController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_user, :get_group

  def index
    # Looks at the user's group id and shows all ideas that belong to that group
    @ideas = @group.ideas.all
    #@ideas = @user.ideas.all
  end


  def show
    #Looks to see if the user's group has access to an idea & redirects if they dont
    if @group.ideas.find_by_id(params[:id])
      @idea = @group.ideas.find(params[:id])
    else
      redirect_to ideas_path, :notice => "That idea doesn't exist!"
    end
  end

  def new
  	@idea = Idea.new
    @ideatype_options = Ideatype.where('active = true').all.map {|i| [i.name, i.id]}
  end

  def create
  	@idea = Idea.create(idea_params)
    @idea.user = current_user

  	if @idea.save
  		redirect_to ideas_path, :notice =>"The idea was saved!"
  	else
      render :action => "new"
  	end
  end

  def edit
    #Looks to see if the user's group has access to an idea & redirects if they don't
    if @group.ideas.find_by_id(params[:id])
      @idea = Idea.find(params[:id])
      @ideatype_options = Ideatype.where('active = true').all.map {|i| [i.name, i.id]}
    else
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end
  end

  def update
    #Looks to see if the user's group has access to an idea & redirects if they don't
    if @group.ideas.find_by_id(params[:id])
      @idea = Idea.find(params[:id])
    else
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end

  	if @idea.update_attributes(idea_params)
  		redirect_to ideas_path, :notice =>"The idea is updated!"
  	else
      render :action => "edit"
  	end

  end

  def destroy
    #Looks to see if the user's group has access to an idea & redirects if they don't
    if @group.ideas.find_by_id(params[:id])
      @idea = Idea.find(params[:id])
    else
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end
    
  	@idea.destroy
  	redirect_to ideas_path, :notice => "Your idea was deleted!"
  end

  private

  def idea_params
    params.require(:idea).permit(:name, :description, :ideatype_id)
  end

  def get_user
    @user = current_user
  end

  def get_group
    @group = @user.group
  end

end
