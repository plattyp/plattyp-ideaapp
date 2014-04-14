class IdeaMessagesController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user

	def index
		@messages = @idea.idea_messages.all
	end

	def show
	end

	def new
		@message = @idea.idea_messages.build
		@message.user_id = @user.id
		respond_with(@message)
	end

	def create
		@message = @idea.idea_messages.build(message_params)
		@message.user_id = @user.id
		if @message.save
			redirect_to edit_idea_path(@idea), :notice => "Your message was sent!"
		else
			redirect_to new_idea_ideamessage_path(@idea), :notice => "Sorry, but your message could not be sent"
		end
	end

	private

	def message_params
		params.require(:idea_message).permit(:idea_id, :user_id, :message)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end

	def get_user
		@user = current_user
	end
end
