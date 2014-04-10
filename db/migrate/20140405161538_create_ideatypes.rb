class CreateIdeatypes < ActiveRecord::Migration
  def change
    create_table :ideatypes do |t|
      t.string :type
      t.boolean :active

      t.timestamps
    end
  end
end
