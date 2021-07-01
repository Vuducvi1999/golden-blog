class AddFacebookIdPostToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :post_facebook_id, :string
  end
end
