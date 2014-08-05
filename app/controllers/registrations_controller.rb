class RegistrationsController < Devise::RegistrationsController

	def create
		super
		if resource.save
			set_flash_message :notice, :signed_up

			#Onboarding methods
			@user = User.onboarduser(resource)
		else
			clean_up_passwords(resource)
		end
	end

	def edit
		#Used to fill hidden value on edit form for the joinsecret
		returnedsignups = Setting.retrieve_adminvalues("Join Secret")

		#The @signupcode is passed in the form back to the update method
		returnedsignups.each do |i|
			@signupcode = i.value
		end
	end
	
	private

  	def sign_up_params
    	params.require(:user).permit(:email, :password, :password_confirmation, 
				     :username, :group_id, :signupcode,:provider, :uid)
  	end

	def account_update_params
		params.require(:user).permit(:email, :password, :current_password, 
  					 :password_confirmation, :username, :group_id, :provider, :uid, :signupcode)
	end
end
