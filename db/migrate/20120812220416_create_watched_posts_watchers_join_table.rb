class CreateWatchedPostsWatchersJoinTable < ActiveRecord::Migration
  def change
    create_table :watched_posts_watchers, :id => false do |t|
      t.integer :watched_post_id
      t.integer :watcher_id
    end
  end
end
