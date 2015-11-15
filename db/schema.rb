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

ActiveRecord::Schema.define(version: 20151115142510) do

  create_table "mailing_lists", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mailing_lists", ["name"], name: "index_mailing_lists_on_name", unique: true

  create_table "messages", force: :cascade do |t|
    t.string   "author"
    t.text     "source"
    t.integer  "mailing_list_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "messages", ["mailing_list_id"], name: "index_messages_on_mailing_list_id"

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mailing_list_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "subscriptions", ["mailing_list_id"], name: "index_subscriptions_on_mailing_list_id"
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email_address"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
