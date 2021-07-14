class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy 

  validates :content, presence: true, allow_blank: false 

  scope :order_created_at, -> { order(created_at:'desc')}
  
end 
