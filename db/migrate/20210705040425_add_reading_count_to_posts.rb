class AddReadingCountToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :read_count?, :integer, default:0
  end
end
