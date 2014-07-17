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

		#Subfeature Categories
			@subfeaturecategories = Setting.retrieve_groupvalues(@group.id,"Subfeature Category")

			#To create an instance varaible from index
			@subfeaturecategory = Setting.new
	end

	def create
		@setting = @user.settings.build(setting_params)
		@setting.group_id = @group.id
		
		if @setting.save
			redirect_to settings_path, :notice => "The #{@setting.settingtype} was added!"
		else
			redirect_to settings_path, :notice => "The #{@setting.settingtype} was unable to be added!"
		end

	end

	def destroy
		@setting = @group.settings.find_by_id(params[:id])
		if @setting.destroy
			redirect_to settings_path, :notice => "The #{@setting.settingtype} was deleted!"
		else
			redirect_to settings_path, :notice => "The #{@setting.settingtype} was unable to be deleted!"
		end
	end

	private

	def setting_params
		params.require(:setting).permit(:settingtype, :value, :user_id, :group_id)
	end

	def get_user
		@user = current_user
	end

	def get_group
		@group = @user.group
	end
end
