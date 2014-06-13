class Inviteduser < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea

	def self.return_invitedusers(idea_id, emails)
		Inviteduser.where("idea_id = ? AND emailaddress not in (?)",idea_id,emails).select("emailaddress","role")
	end

	def self.search_invited(emailaddress, idea_id)
		Inviteduser.where("emailaddress = ? AND idea_id = ?",emailaddress,idea_id)
	end

	def self.return_ideasforgivenuser(email)
		Inviteduser.where("emailaddress = ?",email)
	end
end
