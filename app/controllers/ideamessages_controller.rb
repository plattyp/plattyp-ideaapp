class IdeamessagesController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user

	def index
		@ideamessages = @idea.ideamessages.all

		#Create an instance variable to allow new messages created on the invex
		@ideamessage = @idea.ideamessages.build
	end

	def show
	end

	def new
		@ideamessage = @idea.ideamessages.build
		respond_with(@ideamessage)
	end

	def create
		@ideamessage = @idea.ideamessages.build(message_params)
		@ideamessage.user_id = @user.id
		if @ideamessage.save
			redirect_to idea_ideamessages_path(@idea), :notice => "Your message was sent!"
		else
			redirect_to idea_ideamessages_path(@idea), :notice => "Sorry, but your message could not be sent"
		end
	end

	private

	def message_params
		params.require(:ideamessage).permit(:idea_id, :user_id, :message)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end

	def get_user
		@user = current_user
	end
end
