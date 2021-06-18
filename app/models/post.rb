class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :categories, presence: { message:"must be given please"}
  validates :thumbnail, presence: { message:"must be given please"}
  
  has_rich_text :content
  has_one_attached :thumbnail
  
  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

  has_many :comments, dependent: :destroy
end
