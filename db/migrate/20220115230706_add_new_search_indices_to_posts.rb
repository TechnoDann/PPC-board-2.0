class AddNewSearchIndicesToPosts < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, %{to_tsvector('english', subject)}, using: :gin, name: :index_posts_subjects_for_search
    add_index :posts, %{to_tsvector('english', author)}, using: :gin, name: :index_posts_authors_for_search
    add_index :posts, %{to_tsvector('english', body)}, using: :gin, name: :index_posts_bodies_for_search
  end
end
