class IdeausersController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea
	
	def index
	end

	def new
		@user = @idea.ideausers.build
	end

	def create
		@user = @idea.ideausers.build(ideauser_params)

		if @user.save
			redirect_to idea_ideauser_path(@idea), :notice => "The user was added!"
		else
			redirect_to idea_ideauser_path(@idea), :notice => "The user could not be added."
		end
	end

	def destroy
		@user = Ideauser.find_by_user_id_and_idea_id(params[:user_id],params[:idea_id])
		@user.destroy
		redirect_to idea_invitedusers_path(@idea), :notice => "The user was removed."
	end

	private

	def ideauser_params
		params.require(:ideauser).permit(:user_id, :idea_id, :role)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end
end
