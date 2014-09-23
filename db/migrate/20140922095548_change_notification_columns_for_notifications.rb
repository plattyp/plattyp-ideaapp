class ChangeNotificationColumnsForNotifications < ActiveRecord::Migration
  def change
  	rename_column :notifications, :notification_id, :notifiable_id
  	rename_column :notifications, :notification_type, :notifiable_type
  end
end
