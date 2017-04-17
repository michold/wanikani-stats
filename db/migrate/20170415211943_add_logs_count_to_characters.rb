class AddLogsCountToCharacters < ActiveRecord::Migration[5.0]
  def change
  	add_column :characters, :logs_count, :integer, :default => 0, :null => false
  end
end
