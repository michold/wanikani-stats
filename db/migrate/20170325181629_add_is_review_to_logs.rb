class AddIsReviewToLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :logs, :is_review, :boolean, :default => true
  end
end
