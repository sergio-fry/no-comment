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

ActiveRecord::Schema.define(version: 20140821080200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pages", force: true do |t|
    t.text     "url",                                  null: false
    t.text     "title"
    t.text     "description"
    t.string   "domain",                               null: false
    t.text     "img"
    t.integer  "comments_count",  default: 0
    t.text     "additional_info", default: "--- {}\n"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
    t.integer  "status",          default: 0,          null: false
  end

  add_index "pages", ["comments_count"], name: "index_pages_on_comments_count", using: :btree
  add_index "pages", ["created_at"], name: "index_pages_on_created_at", using: :btree
  add_index "pages", ["domain"], name: "index_pages_on_domain", using: :btree
  add_index "pages", ["status"], name: "index_pages_on_status", using: :btree
  add_index "pages", ["updated_at"], name: "index_pages_on_updated_at", using: :btree
  add_index "pages", ["url"], name: "index_pages_on_url", using: :btree

end
