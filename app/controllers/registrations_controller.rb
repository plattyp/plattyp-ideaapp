class RegistrationsController < Devise::RegistrationsController
	after_filter :add_invitedideas, :add_usertogroup

	def manage_account
	end
	
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
			#Create Group
			group = Group.new

			#Assign Group Name
			group.name = resource.username + "'s group"

			#Generate random secret code to join
			o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
			group.joinsecret = (0...25).map { o[rand(o.length)] }.join

			#Save the group
			group.save

			#Update the user with a group id
			resource.group_id = group.id

			resource.save

			#After the group is added, call method to onboard initial settings for user/group
			add_initialsettings
		end
	end

	def add_initialsettings
		if resource.persisted? # user is created successfuly
			#Find user account
			@onboarduser = User.find_by_id(resource.id)

			#Find group by user
			@onboardgroup = @user.group

			#Initial subfeature categories for a given user (Should eventually be modified by Admin to be dynamic)
			@initialsettings = Setting.retrieve_adminvalues(params[:settingtype])

			#Create new instance
			@initialsettings.each do |i|
				initalsetting = Setting.create(:settingtype => i.settingtype, :value => i.value, :user_id => resource.id, :group_id => @onboardgroup.id)
			end
		end
	end

end
