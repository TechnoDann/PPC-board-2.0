class AddBeingClonedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :being_cloned, :boolean, :default => false
  end
end
