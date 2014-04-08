class Idea < ActiveRecord::Base
	belongs_to :ideatype
	belongs_to :user
	has_many :features

	#Basic validation
	validates :name, :presence => true
	validates :description, :presence => true
	validates :ideatype, :presence => true
	validates :user, :presence => true

	#Going to be used to capitalize the idea before saving
	def name=(s)
		write_attribute(:name, s.to_s.titleize)
	end
end