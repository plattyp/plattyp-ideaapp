class Domain < ActiveRecord::Base
	has_many :ideas, :through => :ideadomains
	has_many :ideadomains

	accepts_nested_attributes_for :ideadomains, :allow_destroy => true

	def self.search(search)
	  search_condition = search
	  find(:all, :conditions => ['url = ?', search_condition])
	end
end
