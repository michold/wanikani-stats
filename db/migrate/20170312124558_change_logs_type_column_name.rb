class ChangeLogsTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :logs, :type, :item_type
  end
end
