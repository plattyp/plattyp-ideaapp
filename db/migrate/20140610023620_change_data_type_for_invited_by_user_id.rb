class ChangeDataTypeForInvitedByUserId < ActiveRecord::Migration
  def change
  	change_column :invitedusers, :invited_by_user_id, 'integer USING CAST(invited_by_user_id AS integer)'
  end
end
