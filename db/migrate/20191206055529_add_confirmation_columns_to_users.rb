class AddConfirmationColumnsToUsers < ActiveRecord::Migration[5.2]
  def up
    change_table(:users) do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end

    User.update_all confirmed_at: DateTime::parse('2019-10-31 00:00:00')

    add_index :users, :confirmation_token,   :unique => true
  end

  def down
    remove_index :users, :confirmation_token
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :unconfirmed_email # Only if using reconfirmable
  end
end
