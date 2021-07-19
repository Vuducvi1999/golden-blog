class ChangeLikesToComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :likes

    create_table :likes do |t| 
      t.references :likeable, polymorphic: true, null: false 
      t.references :user, null: false, foreign_key: true 
      t.timestamps 
    end
  end
end
