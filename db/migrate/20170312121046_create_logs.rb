class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :unlocked_date
      t.text :meaning_note
      t.text :reading_note
      t.string :srs
      t.integer :srs_numeric
      t.datetime :available_date
      t.boolean :burned
      t.datetime :burned_date
      t.datetime :reactivated_date
      t.integer :meaning_correct
      t.integer :meaning_incorrect
      t.integer :meaning_max_streak
      t.integer :meaning_current_streak
      t.integer :reading_correct
      t.integer :reading_incorrect
      t.integer :reading_max_streak
      t.integer :reading_current_streak
      t.string :type

      t.timestamps null: false
    end
  end
end
