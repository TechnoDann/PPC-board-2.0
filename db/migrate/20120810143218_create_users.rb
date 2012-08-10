class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.boolean :moderator, :default => false

      t.timestamps
    end
    add_index :users, :name, :unique => true
    add_index :users, :email, :unique => true
  end
end
