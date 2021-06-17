class Category < ApplicationRecord
  validates :name, presence: true
  has_many :post_categories, dependent: :destroy
  has_many :posts, through: :post_categories, dependent: :destroy
end
