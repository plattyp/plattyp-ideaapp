class RemoveIntegerFromInvitedusers < ActiveRecord::Migration
  def change
    remove_column :invitedusers, :integer
  end
end
