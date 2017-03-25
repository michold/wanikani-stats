class CreateLevelCounts < ActiveRecord::Migration
  def change
    create_table :level_counts do |t|
      t.datetime :date
      t.integer :level
      t.integer :amount

      t.timestamps null: false
    end
  end
end
