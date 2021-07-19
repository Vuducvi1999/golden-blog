class Notification < ApplicationRecord
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  belongs_to :notifiable, polymorphic: true 
  
  scope :ordered, -> { order(created_at:'desc') }
  scope :unread, -> { where(readed: false) }
end
