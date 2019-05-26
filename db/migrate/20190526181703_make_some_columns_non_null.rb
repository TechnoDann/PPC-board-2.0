class MakeSomeColumnsNonNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :posts, :locked, false, false
    change_column_null :posts, :poofed, false, false

    change_column_default :posts, :locked, false
    change_column_default :posts, :poofed, false

    change_column_null :posts, :sort_timestamp, false

    change_column_null :posts, :user_id, false

    change_column_null :tags, :name, false

    change_column_null :posts, :subject, false
    change_column_null :posts, :author, false
  end
end
