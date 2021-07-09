class AddFacebookIdPosDefaulttToPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :post_facebook_id, :string, default:''
  end
end
