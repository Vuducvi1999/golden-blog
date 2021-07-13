class AddCommentAttrsToComments < ActiveRecord::Migration[6.1]
  def change
    remove_reference :comments, :post, index: true, foreign_key: true 
    add_reference :comments, :commentable, polymorphic: true, null: false
    add_column :comments, :likes, :integer, default: 0 
  end
end
