class AddColumnsToIdeatype < ActiveRecord::Migration
  def change
  	add_column :ideatypes, :group_id, :integer
  end
end
