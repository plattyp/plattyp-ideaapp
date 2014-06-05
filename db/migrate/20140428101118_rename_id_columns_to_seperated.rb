class RenameIdColumnsToSeperated < ActiveRecord::Migration
  def self.up
  	rename_column :ideausers, :userid, :user_id
  	rename_column :ideausers, :ideaid, :idea_id
  end
end
