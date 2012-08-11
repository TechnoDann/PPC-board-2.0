class CreateBans < ActiveRecord::Migration
  def change
    create_table :bans do |t|
      t.integer :user_id
      t.string :ip
      t.string :email
      t.integer :length, :null => false, :default => 60
      t.string :reason, :null => false, :limit => 500

      t.timestamps
    end
    add_index :bans, :ip
    add_index :bans, :email
  end
end
