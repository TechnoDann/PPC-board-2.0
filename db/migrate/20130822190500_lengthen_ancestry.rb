class LengthenAncestry < ActiveRecord::Migration
  def up
    change_column :posts, :ancestry, :text
  end

  def down
    change_column :posts, :ancestry, :string
  end
end
