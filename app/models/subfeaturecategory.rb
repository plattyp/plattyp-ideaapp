class Subfeaturecategory < ActiveRecord::Base
	belongs_to :idea
	has_many :subfeatures, dependent: :destroy

	def self.returnideacategories(idea_id)
		Subfeaturecategory.where("idea_id = ?",idea_id).select("id","categoryname")
	end

	def self.returncategoryname(id)
		Subfeaturecategory.where("id = ?",id).select("categoryname")
	end

	def self.idea_subfeature_count(idea_id,subfeaturecategory_id)
		Subfeaturecategory.joins(:subfeatures).where("subfeatures.idea_id = ? AND subfeaturecategory_id = ?", idea_id, subfeaturecategory_id).count
	end
end
