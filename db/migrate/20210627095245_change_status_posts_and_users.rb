class ChangeStatusPostsAndUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :status, :integer, null:false, default:0
    change_column :users, :role, :integer, null:false, default:0
  end
end
