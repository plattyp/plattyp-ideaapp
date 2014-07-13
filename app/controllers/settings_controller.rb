class SettingsController < ApplicationController
	before_action :get_user
	
	def index
	end

	private

	def get_user
		@user = current_user
	end
end
