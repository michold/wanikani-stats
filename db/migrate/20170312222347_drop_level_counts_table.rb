class DropLevelCountsTable < ActiveRecord::Migration
  def change
  	drop_table :level_counts
  end
end
