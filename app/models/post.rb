class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :categories, presence: { message:"must be given please"}
  validates :thumbnail, presence: { message:"must be given please"}

  before_create :set_post_created_is_new
  
  has_rich_text :content
  has_one_attached :thumbnail, dependent: :destroy
  
  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories, dependent: :destroy
  has_many :comments, dependent: :destroy

  acts_as_votable

  STATUS = {
    new: 0,
    approved: 1,
    rejected: 2
  }

  scope :filter_by_categories, ->(categories_id){ where "post_categories.category_id in (#{categories_id.join(',')})" }
  scope :search_by, ->(post_title){ joins(:post_categories)
                                    .where(["lower(title) like ?","%#{post_title.downcase}%"])
                                    .order(updated_at: :desc) }
  def is_approved?
    self.status == Post::STATUS[:approved]
  end

  def is_new?
    self.status == Post::STATUS[:new]
  end

  def is_rejected?
    self.status == Post::STATUS[:new]
  end

  private
  def set_post_created_is_new
    post.status = Post::STATUS[:new]
  end

end
