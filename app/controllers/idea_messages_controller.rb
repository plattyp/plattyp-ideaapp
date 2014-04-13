class IdeaMessagesController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea

	def index
		@messages = @idea.ideamessages.all
	end

	def show
	end

	def new
		@message = @idea.ideamessages.build
		respond_with(@message)
	end

	def create
		@message = @idea.ideamessages.build(message_params)
		if @message.save
			redirect_to edit_idea_path(@idea), :notice => "Your message was sent!"
		else
			redirect_to new_idea_ideamessage_path(@idea), :notice => "Sorry, but your message could not be sent"
		end
	end

	private

	def message_params
		params.require(:feature).permit(:idea_id, :user_id, :message)
	end

	def get_idea
		@idea = Idea.find(params[:id])
	end
end
