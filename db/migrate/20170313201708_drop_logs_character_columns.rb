class DropLogsCharacterColumns < ActiveRecord::Migration
  def change
	  remove_column :logs, :char
	  remove_column :logs, :image
	  remove_column :logs, :item_type
  end
end
