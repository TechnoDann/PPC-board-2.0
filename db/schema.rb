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

ActiveRecord::Schema.define(version: 20160727003452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bans", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "ip",         limit: 255
    t.string   "email",      limit: 255
    t.integer  "length",                 default: 60, null: false
    t.string   "reason",     limit: 500,              null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "bans", ["email"], name: "index_bans_on_email", using: :btree
  add_index "bans", ["ip"], name: "index_bans_on_ip", using: :btree

  create_table "posts", force: :cascade do |t|
    t.boolean  "locked"
    t.boolean  "poofed"
    t.datetime "sort_timestamp"
    t.string   "subject",             limit: 255
    t.integer  "user_id"
    t.string   "author",              limit: 255
    t.text     "body"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.text     "ancestry"
    t.integer  "previous_version_id"
    t.integer  "next_version_id"
    t.boolean  "being_cloned",                    default: false
  end

  add_index "posts", ["ancestry"], name: "index_posts_on_ancestry", using: :btree, order: {ancestry: "text_pattern_ops ASC NULLS FIRST"}
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "posts_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "post_id"
  end

  create_table "posts_users", id: false, force: :cascade do |t|
    t.integer "post_id"
    t.integer "user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255,                 null: false
    t.string   "email",                  limit: 255, default: "",    null: false
    t.boolean  "moderator",                          default: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "guest_user",                         default: true
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "bans", "users", name: "bans_user_id_fk"
  add_foreign_key "posts", "posts", column: "next_version_id", name: "posts_next_version_id_fk"
  add_foreign_key "posts", "posts", column: "previous_version_id", name: "posts_previous_version_id_fk"
  add_foreign_key "posts", "users", name: "posts_user_id_fk"
  add_foreign_key "posts_tags", "posts", name: "posts_tags_post_id_fk"
  add_foreign_key "posts_tags", "tags", name: "posts_tags_tag_id_fk"
  add_foreign_key "posts_users", "posts", name: "posts_users_post_id_fk"
  add_foreign_key "posts_users", "users", name: "posts_users_user_id_fk"
end
