class AddShowEmailColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :show_email, :boolean, default: false, null: false
  end
end
