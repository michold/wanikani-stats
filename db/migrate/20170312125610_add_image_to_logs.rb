class AddImageToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :image, :string
  end
end
