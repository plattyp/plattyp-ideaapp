class Ideauser < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea

	def self.return_associatedid(idea_id,user_id)
		Ideauser.where("idea_id = ? AND user_id = ?",idea_id,user_id).select("id")
	end
end
