class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :notification_id
      t.string :notification_type

      t.timestamps
    end
  end
end
