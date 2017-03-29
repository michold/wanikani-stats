class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :gravatar
      t.integer :level
      t.string :title
      t.datetime :creation_date
      t.integer :radicals_progress
      t.integer :radicals_total
      t.integer :kanji_progress
      t.integer :kanji_total

      t.timestamps
    end
  end
end
