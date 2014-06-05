class Subfeature < ActiveRecord::Base
	belongs_to :feature
	belongs_to :idea
	belongs_to :user

	def self.unique_categories(feature)
		Subfeature.where("feature_id = ?",feature).uniq.pluck(:category)
	end

	def self.subfeature_count(feature,category)
		Subfeature.where("feature_id = ? AND category = ?", feature, category).count
	end


	def self.select_where(feature,category)
		if category.blank?
			Subfeature.where("feature_id = ?", feature).all
		else
			Subfeature.where("feature_id = ? AND category = ?", feature, category).all
		end
	end
end
