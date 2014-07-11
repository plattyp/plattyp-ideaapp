class Subfeaturecategory < ActiveRecord::Base
	belongs_to :idea
	has_many :subfeatures, dependent: :destroy

	#Returns subcategory_id and name based on an Idea_id
	def self.returnideacategories(idea_id)
		Subfeaturecategory.where("idea_id = ?",idea_id).select("id","categoryname")
	end

	#Returns the amount of subfeatures that exist across a given idea for a given subfeaturecategory
	def self.idea_subfeature_count(idea_id,subfeaturecategory_id)
		Subfeaturecategory.joins(:subfeatures).where("subfeatures.idea_id = ? AND subfeaturecategory_id = ?", idea_id, subfeaturecategory_id).count
	end
end
