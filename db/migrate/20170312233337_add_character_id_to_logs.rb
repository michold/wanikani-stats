class AddCharacterIdToLogs < ActiveRecord::Migration
  def change
	add_column :logs, :character_id, :integer
	add_index  :logs, :character_id
  end
end