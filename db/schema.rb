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

ActiveRecord::Schema.define(version: 20141209165950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "refresh_audits", force: true do |t|
    t.string   "period"
    t.datetime "stamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.integer  "zenid"
    t.datetime "opened"
    t.datetime "closed"
    t.datetime "first_assigned"
    t.integer  "closed_time"
    t.integer  "reply_time"
    t.string   "product"
    t.string   "agent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "originally_created"
    t.datetime "originally_closed"
    t.integer  "replies"
  end

  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree
  add_index "tickets", ["zenid"], name: "index_tickets_on_zenid", using: :btree

  create_table "users", force: true do |t|
    t.integer  "zenid"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["zenid"], name: "index_users_on_zenid", using: :btree

end
