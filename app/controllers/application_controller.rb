class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #This forces authentication for any part of the site
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me, :provider, :uid)}
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :current_password,:password_confirmation, :username, :group_id, :provider, :uid, :signupcode)}
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :current_password, :password_confirmation, :username, :group_id, :provider, :uid, :signupcode)}
  end

  #Checks a user status and redirects if the appropriate status isn't obtained
  def check_user_status
    user = current_user
    if user && user.status != 2
      redirect_to signupcode_settings_path
    end
  end

end
