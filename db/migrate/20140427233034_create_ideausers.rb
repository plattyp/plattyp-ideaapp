class CreateIdeausers < ActiveRecord::Migration
  def change
    create_table :ideausers do |t|
      t.integer :userid
      t.integer :ideaid

      t.timestamps
    end
  end
end
