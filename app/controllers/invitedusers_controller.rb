class InvitedusersController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user, :check_user_access

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
		role = "Particpant"
		@inviteduser.role = role

		#Checks to see if a matching user already exists in the system
		@matcheduser = User.search_users(@inviteduser.emailaddress)

		#Checks to see if an invite was already send for this user
		@invitedusercheck = Inviteduser.search_invited(@inviteduser.emailaddress, @idea.id)

		if @invitedusercheck.count === 0
			if @inviteduser.save
				#Checks to see if a current user with that email exists
				if @matcheduser.count === 0
					#If he doesn't exist, an email is sent to the user
					InviteduserMailer.invited_email(@inviteduser.emailaddress).deliver
					redirect_to idea_invitedusers_path(@idea), :notice => "An email was sent to invite the user!"
				else
					#If user already is a member of the site, it will add him to the workroom
					@matcheduser.each do |user|
						Ideauser.create(:user_id => user.id, :idea_id => @idea.id, :role => role)
						InviteduserMailer.addedtoidea_email(user.email, @idea).deliver
						redirect_to idea_invitedusers_path(@idea), :notice => "The user was added to the workroom successfully!"
					end
				end
			else
				redirect_to idea_invitedusers_path(@idea),     :notice => "Sorry, but the user could not be added."
			end
		else
			redirect_to idea_invitedusers_path(@idea), :notice => "The user has already been invited!"
		end
	end

	def destroy
		@inviteduser = @idea.invitedusers.find(params[:id])
		@inviteduser.destroy
		redirect_to idea_invitedusers_path(@idea), :notice => "The user was uninvited."
	end

	private

	def inviteduser_params
		params.require(:inviteduser).permit(:emailaddress)
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
end
