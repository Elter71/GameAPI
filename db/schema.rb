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

ActiveRecord::Schema.define(version: 20170907124454) do

  create_table "arenas", force: :cascade do |t|
    t.text "character_1_name"
    t.text "character_2_name"
    t.text "status"
    t.text "winner_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characters", primary_key: "name", id: :text, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "sqlite_autoindex_characters_1", unique: true
  end

  create_table "levels", primary_key: "level", force: :cascade do |t|
    t.integer "experience_to_next"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statistics", primary_key: "character_name", id: :text, force: :cascade do |t|
    t.integer "stamina"
    t.integer "strength"
    t.integer "dexterity"
    t.integer "experience"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_name"], name: "sqlite_autoindex_statistics_1", unique: true
  end

  create_table "users", id: false, force: :cascade do |t|
    t.integer "number"
    t.text "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "character_name"
  end

end
