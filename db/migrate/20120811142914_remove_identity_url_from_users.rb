class RemoveIdentityUrlFromUsers < ActiveRecord::Migration
  def up
    remove_index :users, :identity_url
    remove_column :users, :identity_url
  end

  def down
    add_column :users, :identity_url, :string, :default => "", :null => false
    add_index :users, :identity_url, :unique => true
  end
end
