class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.text :message
      t.boolean :readed, default: false
      t.references :sender, null: false
      t.references :recipient, null: false

      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :sender_id
    add_foreign_key :notifications, :users, column: :recipient_id
  end
end
