class CreateWatchedPostsWatchersJoinTable < ActiveRecord::Migration
  def change
    create_table :posts_users, :id => false do |t|
      t.integer :post_id
      t.integer :user_id
    end
  end
end
