class Inviteduser < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea

	#Basic email validation
	validates :emailaddress, :email => { :allow_nil => false, :message => 'Not a valid email address' }

	def self.return_invitedusers(idea_id, emails)
		Inviteduser.where("idea_id = ? AND emailaddress not in (?)",idea_id,emails).select("emailaddress","role","id")
	end

	# def self.search_invited(emailaddress, idea_id)
	# 	Inviteduser.where("emailaddress = ? AND idea_id = ?",emailaddress,idea_id)
	# end

	def self.return_ideasforgivenuser(email)
		Inviteduser.where("emailaddress = ?",email)
	end
end
