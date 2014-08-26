class ChangeImageurlColumnForUsers < ActiveRecord::Migration
  def change
  	change_column :users, :imageurl, :text
  end
end
