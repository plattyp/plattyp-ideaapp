class AddColumnsToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :admin_default, :boolean, :default => false
  end
end
