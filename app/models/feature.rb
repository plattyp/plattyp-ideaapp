class Feature < ActiveRecord::Base
	belongs_to :idea
	has_many :subfeatures, dependent: :destroy
end
