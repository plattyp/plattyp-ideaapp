class NotificationMailer < ActionMailer::Base
  default from: ENV["FROM_EMAIL"]
  default_url_options[:host] = ENV["DEFAULT_URL_MAIL_OPTIONS"]

  def notification_email(email,body)
  	@body = body
  	mail(to: email, subject: 'You have received a notification on an idea')
  end
end
