class CreateSubfeaturecategories < ActiveRecord::Migration
  def change
    create_table :subfeaturecategories do |t|
      t.string :categoryname
      t.integer :idea_id

      t.timestamps
    end
  end
end
