class RegistrationsController < Devise::RegistrationsController
	after_filter :add_invitedideas, :add_usertogroup

	private

	def add_invitedideas
	    if resource.persisted? # user is created successfuly
	    	#search all ideas a user has been invited to prior to sign-up
	    	@allideas = Inviteduser.return_ideasforgivenuser(resource.email)

	    	#iterate through the ideas and add the user to each idea 
	    	@allideas.each do |i|
	    		Ideauser.create(:user_id => resource.id, :idea_id => i.idea_id, :role => i.role)
			end
	    end
	end

	def add_usertogroup
		if resource.persisted?
			Group.create(params[:username])
		end
	end
end
