class CreateInvitedusers < ActiveRecord::Migration
  def change
    create_table :invitedusers do |t|
      t.string :emailaddress
      t.integer :idea_id
      t.string :invited_by_user_id
      t.string :integer
      t.string :role

      t.timestamps
    end
  end
end
