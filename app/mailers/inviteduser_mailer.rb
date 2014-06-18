class InviteduserMailer < ActionMailer::Base
  default from: "contact@platty.co"
  default_url_options[:host] = 'localhost:3000'

  def invited_email(email)
  	mail(to: email, subject: 'You''ve been invited to collaborate on an idea!')
  end

  def addedtoidea_email(email, idea)
  	@idea = idea
  	mail(to: email, subject: 'You''ve been invited to collaborate on an idea!')
  end
end