class RenameTypeColumnToIdeatype < ActiveRecord::Migration
  def self.up
  	rename_column :ideas, :type, :ideatype
  end
end
