class CreateIdeaMessages < ActiveRecord::Migration
  def change
    create_table :idea_messages do |t|
      t.integer :user_id
      t.integer :idea_id
      t.text :message

      t.timestamps
    end
  end
end
