class PostCategory < ApplicationRecord
  belongs_to :post
  belongs_to :category
  
  scope :search_by_post_id, ->(post_id){ where post_id: post_id}
  
  scope :search_by_categories_id, ->(categories_id){ where category_id: categories_id}
end
