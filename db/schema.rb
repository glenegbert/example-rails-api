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

ActiveRecord::Schema.define(version: 2018_11_30_202408) do

  create_table "ads", force: :cascade do |t|
    t.string "creative", null: false
    t.integer "priority", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "goal", null: false
    t.integer "zone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["zone_id"], name: "index_ads_on_zone_id_orderd"
  end

  create_table "zones", force: :cascade do |t|
    t.string "title", null: false
    t.integer "impressions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end