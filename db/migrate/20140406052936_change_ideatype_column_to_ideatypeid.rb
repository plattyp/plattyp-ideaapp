class ChangeIdeatypeColumnToIdeatypeid < ActiveRecord::Migration
  def change
  	change_column :ideas, :ideatype, :integer
  	rename_column :ideas, :ideatype, :ideatype_id 
  end
end
