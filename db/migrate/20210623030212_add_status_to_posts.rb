class AddStatusToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :status, :integer
    add_column :posts, :status_change_at, :datetime
  end
end
