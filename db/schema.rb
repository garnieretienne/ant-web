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

ActiveRecord::Schema.define(version: 20151224144124) do

  create_table "mailboxes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mailboxes", ["name"], name: "index_mailboxes_on_name"

  create_table "mailing_lists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "uid"
    t.integer  "owner_id"
    t.integer  "mailbox_id"
  end

  add_index "mailing_lists", ["mailbox_id"], name: "index_mailing_lists_on_mailbox_id"
  add_index "mailing_lists", ["name"], name: "index_mailing_lists_on_name", unique: true
  add_index "mailing_lists", ["owner_id"], name: "index_mailing_lists_on_owner_id"

  create_table "messages", force: :cascade do |t|
    t.string   "author"
    t.text     "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "mailbox_id"
  end

  add_index "messages", ["mailbox_id"], name: "index_messages_on_mailbox_id"

  create_table "subscribers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "mailing_list_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "subscribers", ["mailing_list_id"], name: "index_subscribers_on_mailing_list_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
  end

end
