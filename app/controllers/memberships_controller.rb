class MembershipsController < Devise::RegistrationsController
	before_action: get_groups

	private

	def get_groups
		@group_options = Group.all.map {|i| [i.name, i.id]}
	end
end