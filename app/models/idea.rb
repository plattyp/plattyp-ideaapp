class Idea < ActiveRecord::Base
	#Serialize a list of ideatype_ids
	serialize :ideatype_ids, Array

	#For a multistep idea creation process
	attr_accessor :step
	attr_writer :step

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
	accepts_nested_attributes_for :features, :reject_if => :all_blank, :allow_destroy => true

	def add_users_form
		collection = ideausers.build
	end

	#Methods for custom retrieval of data
	
	def createdbyuser
		User.first
	end

	#Used for the wizard to easily create ideas
	def self.current_step
		@step.nil? ? 1 : @step
	end

	def self.next_step
		@step = current_step + 1
	end

	def self.previous_step
		@step = current_step - 1
	end

	#Methods to query ideas and their attributes
	def self.returnideas(ideatypes,user_id,searchstring)
		if ideatypes.blank? and searchstring.blank?
			Idea.joins(:ideausers,:ideatype).where("ideausers.user_id = ?", user_id).select("ideas.id","ideas.name","description","ideatype_id").order("ideas.created_at DESC")
		elsif ideatypes.blank? === false and searchstring.blank?
			Idea.joins(:ideausers,:ideatype).where("ideatypes.name IN (?) AND ideausers.user_id = ?", ideatypes, user_id).select("ideas.id","ideas.name","description","ideatype_id").order("ideas.created_at DESC")
		elsif searchstring.blank? === false and ideatypes.blank?
			wildinput = "%" + searchstring.downcase + "%"
			Idea.joins(:ideausers,:ideatype).where("ideausers.user_id = ? AND lower(ideas.name) LIKE ?",user_id, wildinput).select("ideas.id","ideas.name","description","ideatype_id").order("ideas.created_at DESC")
		else
			wildinput = "%" + searchstring.downcase + "%"
			Idea.joins(:ideausers,:ideatype).where("ideatypes.name IN (?) AND ideausers.user_id = ? AND lower(ideas.name) LIKE ?", ideatypes, user_id, wildinput).select("ideas.id","ideas.name","description","ideatype_id").order("ideas.created_at DESC")
		end
	end

	def self.returnideatypes(user_id)
		Idea.joins(:ideatype, :ideausers).where("ideausers.user_id = ?", user_id).uniq.pluck("ideatypes.name","ideatypes.id")
	end

	def self.returndistinctideatypes(user_id)
		Idea.joins(:ideatype, :ideausers).where("ideausers.user_id = ?", user_id).uniq.pluck("ideatypes.name")
	end

	def self.ideacountbyideatype(ideatype_id)
		Idea.where("ideatype_id = ?", ideatype_id).count
	end
	
end