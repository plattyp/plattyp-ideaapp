class ChangeTypeColumnForSetting < ActiveRecord::Migration
  def self.up
  	rename_column :settings, :type, :settingtype
  end
end
