class Ideadomain < ActiveRecord::Base
	belongs_to :idea 
	belongs_to :domain

	def self.search(idea_id,domain_id)
		Ideadomain.where("idea_id = ? AND domain_id = ?",idea_id,domain_id)
	end
end
