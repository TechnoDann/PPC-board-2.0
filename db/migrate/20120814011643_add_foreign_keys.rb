class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key "bans", "users", :name => "bans_user_id_fk"
    add_foreign_key "posts", "posts", :name => "posts_next_version_id_fk", :column => "next_version_id"
    add_foreign_key "posts", "posts", :name => "posts_previous_version_id_fk", :column => "previous_version_id"
    add_foreign_key "posts_tags", "posts", :name => "posts_tags_post_id_fk"
    add_foreign_key "posts_tags", "tags", :name => "posts_tags_tag_id_fk"
    add_foreign_key "posts", "users", :name => "posts_user_id_fk"
    add_foreign_key "posts_users", "posts", :name => "posts_users_post_id_fk"
    add_foreign_key "posts_users", "users", :name => "posts_users_user_id_fk"
  end
end
