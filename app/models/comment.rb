class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy 
  has_many :notifications, as: :notifiable, dependent: :destroy 

  validates :content, presence: true, allow_blank: false 

  scope :order_created_at, -> { order(created_at:'desc')}

  def comments_count 
    count = self.comments.count
    self.comments.each do |item|
      count += item.comments_count
    end
    count 
  end
  
end 
