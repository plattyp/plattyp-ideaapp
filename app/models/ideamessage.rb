class Ideamessage < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea
	#Polymorphic for notifications
	has_many :notifications, as: :notifiable

	validates :message, :presence => true
	default_scope order('created_at DESC')
end
