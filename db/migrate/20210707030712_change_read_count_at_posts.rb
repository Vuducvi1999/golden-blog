class ChangeReadCountAtPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :read_count

    create_table :visits do |t|
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
  end
end
