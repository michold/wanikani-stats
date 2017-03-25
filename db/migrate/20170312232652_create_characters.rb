class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :character
      t.string :important_reading
      t.integer :level
      t.string :kunyomi
      t.string :nanori
      t.string :onyomi
      t.string :meaning
      t.string :kana
      t.string :image
      t.string :type

      t.timestamps null: false
    end
  end
end
