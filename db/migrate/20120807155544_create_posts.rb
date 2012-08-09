class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.boolean :locked
      t.boolean :poofed
      t.timestamp :sort_timestamp
      t.string :subject
      t.integer :user_id
      t.string :author
      t.text :body

      t.timestamps
    end
  end
end
