class AddShortDescriptionToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :short_description, :string
  end
end
