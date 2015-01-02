class InvitedusersController < IdeasController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user, :get_group, :check_user_access, :get_notification_counts

	def index
		@users = InvitedusersHelper.return_alluserslist(@idea.id)

		#Create an instance variable to use to create new invitations on the index
		@inviteduser = @idea.invitedusers.build
	end

	def new
		@inviteduser = @idea.invitedusers.build
	end

	def create
		@inviteduser = @idea.invitedusers.build(inviteduser_params)
		@inviteduser.invited_by_user_id = @user.id
		result = invite_user(@inviteduser)
		redirect_to idea_invitedusers_path(@idea), :notice => result[1]
	end

	def destroy
		@inviteduser = @idea.invitedusers.find(params[:id])
		@inviteduser.destroy
		redirect_to idea_invitedusers_path(@idea), :notice => "The user was uninvited."
	end

	private

	def inviteduser_params
		params.require(:inviteduser).permit(:emailaddress,:role)
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
