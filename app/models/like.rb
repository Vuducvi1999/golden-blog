class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true 
  has_many :notifications, as: :notifiable, dependent: :destroy 
end 
