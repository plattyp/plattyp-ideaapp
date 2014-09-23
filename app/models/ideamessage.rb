class Ideamessage < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea
	#Polymorphic for notifications
	has_many :notifications, as: :notifiable

	validates :message, :presence => true
	default_scope order('created_at DESC')

	def self.return_message_info(message_id)
		Ideamessage.joins(:user).where("ideamessages.id = ?",message_id).select("users.username as sender","idea_id","ideamessages.created_at").first
	end
end
