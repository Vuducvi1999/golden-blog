class CreateBinhluans < ActiveRecord::Migration[6.1]
  def change
    create_table :binhluans do |t|
      t.text :body
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
