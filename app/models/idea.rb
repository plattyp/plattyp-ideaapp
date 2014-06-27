class Idea < ActiveRecord::Base
	#Basic validation
	validates :name, :presence => true
	validates :description, :presence => true
	validates :ideatype_id, :presence => true

	#Going to be used to capitalize the idea before saving
	def name=(s)
		write_attribute(:name, s.to_s.titleize)
	end

	belongs_to :ideatype
	has_many :features, dependent: :destroy
	has_many :subfeatures, :through => :features
	has_many :ideamessages
	has_many :ideausers
	has_many :users, :through => :ideausers
	has_many :domains, :through => :ideadomains
	has_many :ideadomains
	has_many :invitedusers
	has_many :subfeaturecategories

	#For creating Ideauser association records from Idea
	accepts_nested_attributes_for :ideausers, :allow_destroy => true

	def add_users_form
		collection = ideausers.build
	end

	#Methods for custom retrieval of data
	
	def createdbyuser
		User.first
	end

	def self.returnideas(ideatype_id)
		if ideatype_id.blank?
			Idea.select("id","name","description","ideatype_id")
		else
			Idea.where("ideatype_id = ?", ideatype_id).select("id","name","description","ideatype_id")
		end
	end

	def self.returnideatypes
		Idea.joins(:ideatype).uniq.pluck("ideatypes.id","ideatypes.name")
	end
end