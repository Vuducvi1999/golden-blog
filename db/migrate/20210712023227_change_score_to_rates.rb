class ChangeScoreToRates < ActiveRecord::Migration[6.1]
  def change
    change_column :rates, :score, :decimal, precision: 5, scale: 2, default: 0
  end
end
