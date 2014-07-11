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

	def update
		@ideauser = @idea.ideausers.find(params[:id])
		@ideauser.update_attributes(ideauser_params)
	end

	def destroy
		@ideauser = @idea.ideausers.find(params[:id])

		if @ideauser.is_admin
			redirect_to idea_invitedusers_path(@idea), :notice => "The user could not be removed due to being super admin of the idea"
		else
			#Before deletion, check to see if the user has an existing invitation for the idea to delete that as well
			@user = User.return_userinfo(@ideauser.user_id)

			#Search for the invitation using the user's email address and idea id
			@user.each do |u|
				@inviteduser = Inviteduser.search_invited(u.email,@idea.id)
			end

			#Delete invitation if one exists
			@inviteduser.each do |i|
				Inviteduser.destroy(i.id)
			end

			#Then go on destroying the association between the user and the id
			@ideauser.destroy
			redirect_to idea_invitedusers_path(@idea), :notice => "The user was removed."
		end
	end

	def make_admin
		if Ideauser.update(:role => "Admin")
			redirect_to idea_invitedusers_path(@idea), :notice => "The user upgraded to Admin."
		else
			redirect_to idea_invitedusers_path(@idea), :notice => "The user could not be upgraded."
		end
	end

	private

	def ideauser_params
		params.require(:ideauser).permit(:user_id, :idea_id, :role)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end
end
