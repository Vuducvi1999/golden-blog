class Category < ApplicationRecord
  validates :name, presence: true
  has_many :post_categories, dependent: :destroy
  has_many :posts, through: :post_categories, dependent: :destroy

  scope :search_by, ->(categories_id){ where(id: categories_id).pluck(:id, :name) }

end
