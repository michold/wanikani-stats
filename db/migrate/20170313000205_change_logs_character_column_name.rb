class ChangeLogsCharacterColumnName < ActiveRecord::Migration
  def change
  	rename_column :logs, :character, :char
  end
end
