class ChangePostFacebookDefaultToFalse < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :post_facebook?, :boolean, default: false
  end
end
