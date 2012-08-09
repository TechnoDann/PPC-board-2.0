class RemoveParentIdFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :parent_id
    remove_column :posts, :lft
    remove_column :posts, :rgt
  end

  def down
    add_column :posts, :parent_id, :integer
    add_column :posts, :lft, :integer
    add_column :posts, :rgt, :integer
  end
end
