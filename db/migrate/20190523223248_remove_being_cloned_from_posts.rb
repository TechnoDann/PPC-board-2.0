class RemoveBeingClonedFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :being_cloned, :boolean, :default => false
  end
end
