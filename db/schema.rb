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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120808215504) do

  create_table "posts", :force => true do |t|
    t.boolean  "locked"
    t.boolean  "poofed"
    t.datetime "sort_timestamp"
    t.string   "subject"
    t.integer  "user_id"
    t.string   "author"
    t.text     "body"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "ancestry"
    t.integer  "previous_version_id"
    t.integer  "next_version_id"
    t.boolean  "being_cloned",        :default => false
  end

  add_index "posts", ["ancestry"], :name => "index_posts_on_ancestry"

end
