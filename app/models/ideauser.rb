class Ideauser < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea

	def self.return_associatedid(idea_id,user_id)
		Ideauser.where("idea_id = ? AND user_id = ?",idea_id,user_id).select("id","role")
	end

	def self.return_admin(idea_id)
		Ideauser.joins(:user).where("ideausers.idea_id = ? AND ideausers.is_admin = TRUE",idea_id).select("users.username").order("ideausers.created_at ASC")
	end

	def self.return_users(idea_id,user_id=nil)
		if user_id.nil?
			Ideauser.joins(:user).where("idea_id = ?",idea_id).select("ideausers.user_id","users.username","users.email")
		else
			Ideauser.joins(:user).where("idea_id = ? AND user_id <> ?", idea_id, user_id).select("ideausers.user_id","users.username","users.email")
		end
	end
end
