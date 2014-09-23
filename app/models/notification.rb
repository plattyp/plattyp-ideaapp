class Notification < ActiveRecord::Base
	belongs_to :notifiable, polymorphic: true
	belongs_to :sender, class_name: "User" , primary_key: "id"
	belongs_to :receiver, class_name: "User" , primary_key: "id"
end
