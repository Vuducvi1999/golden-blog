class ChangeReadingCountFromPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :read_count?, :read_count
  end
end
