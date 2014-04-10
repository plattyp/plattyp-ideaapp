class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.text :description
      t.integer :idea_id

      t.timestamps
    end
  end
end
