class IdeamessageObserver < ActiveRecord::Observer
	observe :ideamessage

	def after_create(ideamessage)
		@users = Ideauser.return_users(ideamessage.idea_id,ideamessage.user_id)

		#Testing for now, but will be used to create notifications
		@users.each do |u|
			Notification.create!(sender_id: ideamessage.user_id, receiver_id: u.user_id, notifiable: ideamessage)
			#NotificationMailer.notification_email(u.email, ideamessage).deliver
		end
	end
end