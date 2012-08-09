class AddPreviousVersionIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :previous_version_id, :integer
  end
end
