class RenameIdeaMessageToIdeamessage < ActiveRecord::Migration
  def change
  	rename_table :idea_messages, :ideamessages
  end
end
