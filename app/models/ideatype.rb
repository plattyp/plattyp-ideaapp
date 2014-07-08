class Ideatype < ActiveRecord::Base
	has_many :ideas, dependent: :destroy
	belongs_to :group

	def self.returnideatypes(group_id)
		Ideatype.where("group_id = ?", group_id).select("id","name")
	end

end
