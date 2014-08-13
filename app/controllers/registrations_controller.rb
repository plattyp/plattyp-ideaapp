class RegistrationsController < Devise::RegistrationsController

	def create
		super

		#Set the status of the user based on if a signup code was given
		if resource.signupcode === nil
			resource.status = 1 #confirmed but no signupcode entered on Sign Up
		else
			resource.status = 2 #confirmed and signupcode entered on Sign Up
		end

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
	
	def signup
	# For Rails 4
	account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

		# required for settings form to submit when password is left blank
		if account_update_params[:password].blank?
			account_update_params.delete("password")
			account_update_params.delete("password_confirmation")
		end

		@user = User.find(current_user.id)

		#Set status to 2 if the signupcode is valid
		@user.status = 2

		if @user.update_attributes(account_update_params)
			set_flash_message :notice, :updated
			# Sign in the user bypassing validation in case their password changed
			sign_in @user, :bypass => true
			redirect_to after_update_path_for(@user)
		else
			redirect_to signupcode_settings_path, :notice =>"Incorrect sign up code"
		end
	end

	private

	# check if we need password to update user data
	# ie if password or email was changed
	# extend this as needed
	def needs_password?(user, params)
		user.email != params[:user][:email] ||
		params[:user][:password].present? ||
		params[:user][:password_confirmation].present?
	end
end
