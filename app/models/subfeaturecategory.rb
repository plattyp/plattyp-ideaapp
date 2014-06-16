class Subfeaturecategory < ActiveRecord::Base
	belongs_to :idea

	def self.returnideacategories(idea_id)
		Subfeaturecategory.where("idea_id = ?",idea_id).select("id","categoryname")
	end

end
