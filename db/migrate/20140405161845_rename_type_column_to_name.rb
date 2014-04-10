class RenameTypeColumnToName < ActiveRecord::Migration
  def self.up
  	rename_column :ideatypes, :type, :name
  end
end
