class FixAncestryIndexType < ActiveRecord::Migration
  def up
    remove_index :posts, :ancestry
    add_index :posts, :ancestry, order: {ancestry: "text_pattern_ops ASC NULLS FIRST"}
    execute 'ANALYZE posts;'
  end

  def down
    remove_index :posts, :ancestry
    add_index :posts, :ancestry
  end
end
