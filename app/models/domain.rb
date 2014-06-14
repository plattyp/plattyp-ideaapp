class Domain < ActiveRecord::Base
	has_many :ideas, :through => :ideadomains
	has_many :ideadomains

	def self.search(search)
	  find(:all, :conditions => ['url = ?', search])
	end
end
