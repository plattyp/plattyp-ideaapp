class NotificationObserver < ActiveRecord::Observer
	observe :notification

	def after_create(notification)
		NotificationMailer.notification_email(notification.receiver.email, notification).deliver
	end
end