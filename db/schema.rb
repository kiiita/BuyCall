# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140405055756) do

  create_table "orders", force: true do |t|
    t.integer  "user_id",                          null: false
    t.integer  "product_id",                       null: false
    t.integer  "count",            default: 1,     null: false
    t.boolean  "confirm_finished", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name",                   null: false
    t.string   "name_read"
    t.integer  "price",                  null: false
    t.integer  "count",      default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "tel",                null: false
    t.string   "name"
    t.string   "name_voice_url"
    t.string   "zip"
    t.string   "address1"
    t.string   "address2"
    t.string   "address2_voice_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
