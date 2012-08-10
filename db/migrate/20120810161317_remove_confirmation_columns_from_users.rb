class RemoveConfirmationColumnsFromUsers < ActiveRecord::Migration
  def up
    remove_index :users, :confirmation_token
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :unconfirmed_email # Only if using reconfirmable
  end

  def down
    change_table(:users) do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
      add_index :users, :confirmation_token,   :unique => true
    end
  end
end
