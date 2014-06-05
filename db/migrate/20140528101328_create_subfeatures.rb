class CreateSubfeatures < ActiveRecord::Migration
  def change
    create_table :subfeatures do |t|
      t.string :name
      t.text :description
      t.string :category
      t.string :status
      t.integer :idea_id
      t.integer :feature_id
      t.integer :user_id

      t.timestamps
    end
  end
end
