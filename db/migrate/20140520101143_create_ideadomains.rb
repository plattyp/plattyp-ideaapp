class CreateIdeadomains < ActiveRecord::Migration
  def change
    create_table :ideadomains do |t|
      t.integer :idea_id
      t.integer :domain_id
      t.integer :user_id

      t.timestamps
    end
  end
end
