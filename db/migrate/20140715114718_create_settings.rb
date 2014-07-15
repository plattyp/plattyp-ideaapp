class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :type
      t.string :value
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
