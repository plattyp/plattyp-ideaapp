module SubfeaturecategoriesHelper
	def self.returncategory(id)
		Subfeaturecategory.returncategoryname(id)
	end

	def self.returnsubfeaturecount(idea_id,subfeaturecategory_id)
		Subfeaturecategory.idea_subfeature_count(idea_id,subfeaturecategory_id)
	end
end
