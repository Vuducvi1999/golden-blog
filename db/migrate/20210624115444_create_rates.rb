class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.decimal :score, precision: 5, scale: 2
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end

