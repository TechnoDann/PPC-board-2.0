class AddNextVersionIdToPosts < ActiveRecord::Migration
  class Post < ActiveRecord::Base
  end

  def change
    add_column :posts, :next_version_id, :integer
    Post.reset_column_information
    Post.all.each do |post|
      edited = Post.find_by_previous_version_id(post.id)
      if edited
        edited_id = edited.id
      else
        edited_id = nil
      end
      post.update_attributes!({ :next_version_id => edited_id }, :without_protection => true)
      post.save!
    end
  end
end
