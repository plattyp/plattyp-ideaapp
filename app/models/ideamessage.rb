class Ideamessage < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea

	validates :message, :presence => true
	default_scope order('created_at DESC')
end
