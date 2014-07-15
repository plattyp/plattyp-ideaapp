class SettingsController < ApplicationController
	before_action :get_user, :get_group
	
	def index
		#Idea Type Management
			@ideatypes = Ideatype.returnideatypes(@group.id)

			@ideatypeswithcount = Array.new
			@ideatypes.each do |t|
				ideatype = [t.id, t.name, Idea.ideacountbyideatype(t.id)]
				@ideatypeswithcount << ideatype
			end

			#To create an instance variable from index
			@ideatype = Ideatype.new
	end

	def onboard
		@initialcategories = ["Design","Functionality","Business"]
	end

	private

	def get_user
		@user = current_user
	end

	def get_group
		@group = @user.group
	end
end
