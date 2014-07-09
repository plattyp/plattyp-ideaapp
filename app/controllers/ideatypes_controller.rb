class IdeatypesController < ApplicationController
	before_action :get_user, :get_group
	
	def index
		@ideatypes = Ideatype.returnideatypes(@group.id)

		@ideatypeswithcount = Array.new
		@ideatypes.each do |t|
			ideatype = [t.id, t.name, Idea.ideacountbyideatype(t.id)]
			@ideatypeswithcount << ideatype
		end

		#To create an instance variable from index
		@ideatype = Ideatype.new
	end

	def create
		@ideatype = Ideatype.new(ideatype_params)
		@ideatype.group_id = @group.id

		if @ideatype.save
			redirect_to group_ideatypes_path(@group.id), :notice =>"The Idea Type was added!"
		else
			redirect_to group_ideatypes_path(@group.id), :notice =>"The Idea Type could not be added"
		end
	end

	def edit
	end

	def update
	end

	def destroy
		if @group.ideatypes.find_by_id(params[:id])
			@ideatype = @group.ideatypes.find(params[:id])
		else
			redirect_to group_ideatypes_path(@group.id), :notice => "You do not have access to delete this Idea Type"
		end

		@ideatype.destroy
		redirect_to group_ideatypes_path(@group.id), :notice => "The Idea Type was deleted!"

	end

	private

	def ideatype_params
		params.require(:ideatype).permit(:name)
	end

	def get_user
		@user = current_user
	end

	def get_group
		@group = @user.group
	end
end
