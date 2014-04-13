class GroupsController < ApplicationController
	def get_groups
		@groups = Ideatype.all.map {|i| [i.name, i.id]}
	end
end
