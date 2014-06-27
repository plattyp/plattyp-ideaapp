class GroupsController < ApplicationController

	def create
		@group = @group.build(group_params)

		#Generate a random string and assign it to the joinsecret
		o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
		@group.joinsecret = (0...50).map { o[rand(o.length)] }.join

		#This checks to see if a name was selected (If it wasn't it will assign it using the User's username)
		if params[:name].blank?
			@group.name = params[:username]
		else
			@group.name = params[:name]
		end

		#Save the group
		if @group.save
			User.update(:group_id => @group.id)
		end
	end

	def group_params
		params.require(:group).permit(:name)
	end

	def get_groups
		@groups = Ideatype.all.map {|i| [i.name, i.id]}
	end
end
