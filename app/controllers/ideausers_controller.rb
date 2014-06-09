class IdeausersController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea
	
	def index
		@users = @idea.users.all
	end

	def new
		@user = @idea.ideausers.build
	end

	def create
		@user = @idea.ideausers.build

		if @user.save
			redirect_to idea_ideauser_path(@idea), :notice => "The user was added!"
		else
			redirect_to idea_ideauser_path(@idea), :notice => "The user could not be added."
		end
	end


	private

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end
end
