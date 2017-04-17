# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170415211943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.text     "character"
    t.text     "important_reading"
    t.integer  "level"
    t.text     "kunyomi"
    t.text     "nanori"
    t.text     "onyomi"
    t.text     "meaning"
    t.text     "kana"
    t.text     "image"
    t.text     "type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "logs_count",        default: 0, null: false
  end

  create_table "logs", force: :cascade do |t|
    t.datetime "unlocked_date"
    t.text     "meaning_note"
    t.text     "reading_note"
    t.text     "srs"
    t.integer  "srs_numeric"
    t.datetime "available_date"
    t.boolean  "burned"
    t.datetime "burned_date"
    t.datetime "reactivated_date"
    t.integer  "meaning_correct"
    t.integer  "meaning_incorrect"
    t.integer  "meaning_max_streak"
    t.integer  "meaning_current_streak"
    t.integer  "reading_correct"
    t.integer  "reading_incorrect"
    t.integer  "reading_max_streak"
    t.integer  "reading_current_streak"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "character_id"
    t.boolean  "is_review",              default: true
    t.index ["character_id"], name: "index_logs_on_character_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "gravatar"
    t.integer  "level"
    t.string   "title"
    t.datetime "creation_date"
    t.integer  "radicals_progress"
    t.integer  "radicals_total"
    t.integer  "kanji_progress"
    t.integer  "kanji_total"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

end
