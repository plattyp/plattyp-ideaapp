class IdeamessagesController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user

	def index
		@messages = @idea.ideamessages.all
	end

	def show
	end

	def new
		@message = @idea.ideamessages.build
		@message.user_id = @user.id
		respond_with(@message)
	end

	def create
		@message = @idea.ideamessages.build(message_params)
		@message.user_id = @user.id
		if @message.save
			redirect_to edit_idea_ideamessages_path(@idea), :notice => "Your message was sent!"
		else
			redirect_to edit_idea_ideamessages_path(@idea), :notice => "Sorry, but your message could not be sent"
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
