class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :joinsecret

      t.timestamps
    end
  end
end
