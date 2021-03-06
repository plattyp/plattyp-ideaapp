class IdeamessagesController < IdeasController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user, :get_group, :check_user_access, :get_notification_counts

	def index
		@ideamessages = Ideamessage.return_messages(@idea.id)

		#Create an instance variable to allow new messages created on the index
		@ideamessage = @idea.ideamessages.build

    	#Mark unread notifications as read for the user
    	unread = Notification.markread(@idea.id,@user.id,"Ideamessage")
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

	def check_user_access
		unless @user.ideas.find_by_id(params[:idea_id])
			redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
		end
	end

	def get_notification_counts
		@unread_message_count = notification_count(@user.id,@idea.id,"Ideamessage")
	end
end
