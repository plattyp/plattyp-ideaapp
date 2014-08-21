class Idea < ActiveRecord::Base
	#Serialize a list of ideatype_ids
	serialize :ideatype_ids, Array

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
	has_many :subfeaturecategories, dependent: :destroy

	#For creating Ideauser association records from Idea
	accepts_nested_attributes_for :ideausers, :allow_destroy => true

	def add_users_form
		collection = ideausers.build
	end

	#Methods for custom retrieval of data
	
	def createdbyuser
		User.first
	end

	def self.returnideas(ideatype_ids,user_id,searchstring)
		if ideatype_ids.blank? and searchstring.blank?
			Idea.joins(:ideausers).where("ideausers.user_id = ?", user_id).select("ideas.id","name","description","ideatype_id").order("ideas.created_at DESC")
		elsif ideatype_ids.blank? === false and searchstring.blank?
			Idea.joins(:ideausers).where("ideatype_id IN (?) AND ideausers.user_id = ?", ideatype_ids, user_id).select("ideas.id","name","description","ideatype_id").order("ideas.created_at DESC")
		elsif searchstring.blank? === false and ideatype_ids.blank?
			wildinput = "%" + searchstring.downcase + "%"
			Idea.joins(:ideausers).where("ideausers.user_id = ? AND lower(ideas.name) LIKE ?",user_id, wildinput).select("ideas.id","name","description","ideatype_id").order("ideas.created_at DESC")
		else
			wildinput = "%" + searchstring.downcase + "%"
			Idea.joins(:ideausers).where("ideatype_id IN (?) AND ideausers.user_id = ? AND lower(ideas.name) LIKE ?", ideatype_ids, user_id, wildinput).select("ideas.id","name","description","ideatype_id").order("ideas.created_at DESC")
		end
	end

	def self.returnideatypes(user_id)
		Idea.joins(:ideatype, :ideausers).where("ideausers.user_id = ?", user_id).uniq.pluck("ideatypes.name","ideatypes.id")
	end

	def self.ideacountbyideatype(ideatype_id)
		Idea.where("ideatype_id = ?", ideatype_id).count
	end
	
end