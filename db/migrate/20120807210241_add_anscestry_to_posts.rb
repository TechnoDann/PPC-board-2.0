class AddAnscestryToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :ancestry, :string
    add_index :posts, :ancestry
  end

  def self.down
    remove_index :posts, :ancestry
    remove_column :posts, :ancestry, :string
  end
end
