# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_28_012533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brew_methods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "coffees", force: :cascade do |t|
    t.string "origin"
    t.date "roast_date"
    t.integer "price"
    t.bigint "roaster_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["roaster_id"], name: "index_coffees_on_roaster_id"
  end

  create_table "entries", force: :cascade do |t|
    t.date "date"
    t.text "prep_notes"
    t.text "description"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "dose"
    t.integer "output"
    t.time "time"
    t.bigint "brew_method_id", null: false
    t.bigint "coffee_id", null: false
    t.bigint "entry_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brew_method_id"], name: "index_recipes_on_brew_method_id"
    t.index ["coffee_id"], name: "index_recipes_on_coffee_id"
    t.index ["entry_id"], name: "index_recipes_on_entry_id"
  end

  create_table "roasters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "coffees", "roasters"
  add_foreign_key "recipes", "brew_methods"
  add_foreign_key "recipes", "coffees"
  add_foreign_key "recipes", "entries"
end
