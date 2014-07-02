class Domain < ActiveRecord::Base
	has_many :ideas, :through => :ideadomains
	has_many :ideadomains

	#Default sort order
	default_scope order('domainstatus_id ASC, expirationdate ASC')

	def self.search(search)
	  Domain.where("url = ?", search)
	end
end
