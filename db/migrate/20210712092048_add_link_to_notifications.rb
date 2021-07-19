class AddLinkToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :link, :string, null:false, default: ''
  end
end
