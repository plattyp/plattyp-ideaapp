class Notification < ActiveRecord::Base
	belongs_to :notifiable, polymorphic: true
	belongs_to :sender, class_name: "User" , primary_key: "id"
	belongs_to :receiver, class_name: "User" , primary_key: "id"

	def self.return_notificationcount(user_id,type,idea_id=nil)
		if idea_id.nil?
			Notification.where("receiver_id = ? AND notifiable_type = ? AND read = FALSE",user_id,type).count
		else
			Notification.joins('LEFT OUTER JOIN ideamessages ON ideamessages.id = notifications.notifiable_id').where("idea_id = ? AND receiver_id = ? AND notifiable_type = ? AND read = FALSE",idea_id,user_id,type).count
		end
	end

	def self.markread(idea_id,user_id,type)
		case type
		when "Ideamessage"
			unreadnotifications = Notification.joins('LEFT OUTER JOIN ideamessages ON ideamessages.id = notifications.notifiable_id').where("idea_id = ? AND receiver_id = ? AND notifiable_type = ? AND read = FALSE",idea_id,user_id,type).select("notifications.id")
		end

		# Iterate through notifications and mark as read
		unreadnotifications.each do |s|
			notification = Notification.find_by_id(s.id)
			notification.update_attribute(:read,true)
		end
	end
end
