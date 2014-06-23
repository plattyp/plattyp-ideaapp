class Ideatype < ActiveRecord::Base
	has_many :ideas

	def self.returnideatypes
		Ideatype.select("id","name")
	end

end
