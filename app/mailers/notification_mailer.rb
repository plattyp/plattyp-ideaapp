class NotificationMailer < ActionMailer::Base
  default from: ENV["FROM_EMAIL"]
  default_url_options[:host] = ENV["DEFAULT_URL_MAIL_OPTIONS"]

  def notification_email(email,body)
  	# Set the notification properties
  	case body.notifiable_type
  	when "Ideamessage"
  		messageinfo = Ideamessage.return_message_info(body.notifiable_id)
  		subject = "You have received a new message from #{messageinfo.sender}"
  	end

  	# Send out the email
  	mail(to: email, subject: subject)
  end
end
