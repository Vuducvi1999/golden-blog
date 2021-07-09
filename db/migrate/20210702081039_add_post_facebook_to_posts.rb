class AddPostFacebookToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :post_facebook?, :boolean, default:false
  end
end
