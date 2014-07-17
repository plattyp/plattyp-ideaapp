class Group < ActiveRecord::Base
	has_many :users
	has_many :ideatypes
	has_many :ideas, :through => :ideatypes
	has_many :settings
end
