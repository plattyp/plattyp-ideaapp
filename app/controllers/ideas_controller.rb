class IdeasController < ApplicationController
  before_action :get_user

  def index
    @ideas = Idea.all
  end


  def show
  	@idea = Idea.find(params[:id])
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
  		redirect_to new_idea_path, :notice =>"Sorry, but it could not be saved!"
  	end
  end

  def edit
  	@idea = Idea.find(params[:id])
    @ideatype_options = Ideatype.where('active = true').all.map {|i| [i.name, i.id]}
  end

  def update
  	@idea = Idea.find(params[:id])

  	if @idea.update_attributes(idea_params)
  		redirect_to ideas_path, :notice =>"The idea is updated!"
  	else
      render :edit
  	end
  end

  def destroy
  	@idea = Idea.find(params[:id])
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
end
