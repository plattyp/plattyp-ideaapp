class Domain < ActiveRecord::Base
	has_many :ideas, :through => :ideadomains
	has_many :ideadomains

	def self.search(search)
	  Domain.where("url = ?", search)
	end
end
