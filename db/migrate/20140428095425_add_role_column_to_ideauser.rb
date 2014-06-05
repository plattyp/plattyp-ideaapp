class AddRoleColumnToIdeauser < ActiveRecord::Migration
  def change
  	add_column :ideausers, :role, :string
  	add_column :ideausers, :is_admin, :boolean, :default => false
  end
end
