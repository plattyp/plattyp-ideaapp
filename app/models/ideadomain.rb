class Ideadomain < ActiveRecord::Base
	belongs_to :idea 
	belongs_to :domain
end
