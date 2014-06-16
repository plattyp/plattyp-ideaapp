class Subfeature < ActiveRecord::Base
	belongs_to :feature
	belongs_to :idea
	belongs_to :user


	def self.subfeaturestatuslist
		return ["Proposed","Considering","Validated","Approved","Obsolete"]
	end

	def self.unique_categories(feature)
		Subfeature.where("feature_id = ?",feature).uniq.pluck(:category)
	end

	def self.subfeature_count(feature,subfeaturecategory)
		Subfeature.joins(:subfeaturecategories).where("feature_id = ? AND subfeaturecategory_id = ?", feature, subfeaturecategory).count
	end

	def self.select_where(feature,category)
		if category.blank?
			Subfeature.where("feature_id = ?", feature).all
		else
			Subfeature.where("feature_id = ? AND subfeaturecategory_id = ?", feature, category).all
		end
	end
end
