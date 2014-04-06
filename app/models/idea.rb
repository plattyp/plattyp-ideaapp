class Idea < ActiveRecord::Base
	belongs_to :ideatype

	#Going to be used to capitalize the idea before saving
	def name=(s)
		write_attribute(:name, s.to_s.titleize)
	end
end
