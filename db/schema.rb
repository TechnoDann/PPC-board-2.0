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

ActiveRecord::Schema.define(:version => 20130822190500) do

  create_table "bans", :force => true do |t|
    t.integer  "user_id"
    t.string   "ip"
    t.string   "email"
    t.integer  "length",                    :default => 60, :null => false
    t.string   "reason",     :limit => 500,                 :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "bans", ["email"], :name => "index_bans_on_email"
  add_index "bans", ["ip"], :name => "index_bans_on_ip"

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
    t.text     "ancestry"
    t.integer  "previous_version_id"
    t.integer  "next_version_id"
    t.boolean  "being_cloned",        :default => false
  end

  add_index "posts", ["ancestry"], :name => "index_posts_on_ancestry"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "post_id"
  end

  create_table "posts_users", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "user_id"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                      :null => false
    t.string   "email",                  :default => "",    :null => false
    t.boolean  "moderator",              :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "guest_user",             :default => true
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  add_foreign_key "bans", "users", :name => "bans_user_id_fk"

  add_foreign_key "posts", "posts", :name => "posts_next_version_id_fk", :column => "next_version_id"
  add_foreign_key "posts", "posts", :name => "posts_previous_version_id_fk", :column => "previous_version_id"
  add_foreign_key "posts", "users", :name => "posts_user_id_fk"

  add_foreign_key "posts_tags", "posts", :name => "posts_tags_post_id_fk"
  add_foreign_key "posts_tags", "tags", :name => "posts_tags_tag_id_fk"

  add_foreign_key "posts_users", "posts", :name => "posts_users_post_id_fk"
  add_foreign_key "posts_users", "users", :name => "posts_users_user_id_fk"

end
