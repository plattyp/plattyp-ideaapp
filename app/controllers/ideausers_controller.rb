class IdeausersController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea
	
	def index
		@users = @idea.users.all
	end

#This is used as a request to open a modal to invite users to an idea
	def invite_user
		respond_to do |format|
		format.html
		format.js
	end
	end

	private

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end
end
