class RevertAddTextsearchIndexOnPosts < ActiveRecord::Migration[5.2]
  def up
    remove_index :posts, name: :index_posts_on_text_search
  end
  def down
    execute <<ENDSQL
CREATE INDEX index_posts_on_text_search
ON posts
USING gin(
((setweight(to_tsvector('english', coalesce("posts"."subject"::text, '')), 'A') ||
setweight(to_tsvector('english', coalesce("posts"."author"::text, '')), 'C') ||
setweight(to_tsvector('english', coalesce("posts"."body"::text, '')), 'B'))
));
ENDSQL
  end
end
