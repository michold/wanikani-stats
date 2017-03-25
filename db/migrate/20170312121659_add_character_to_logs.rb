class AddCharacterToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :character, :string
  end
end
