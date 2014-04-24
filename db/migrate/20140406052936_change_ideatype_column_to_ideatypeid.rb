class ChangeIdeatypeColumnToIdeatypeid < ActiveRecord::Migration
  def change
  	change_column :ideas, :ideatype, 'integer USING CAST(ideatype AS integer)'
  	#Below was used for MySQL
  	#change_column :ideas, :ideatype, :integer 
  	rename_column :ideas, :ideatype, :ideatype_id 
  end
end
