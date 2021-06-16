class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :categories, presence: { message:"must be given please"}
  has_rich_text :content
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
end
