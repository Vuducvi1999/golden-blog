class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :categories, presence: { message:"must be given please"}
  validates :thumbnail, presence: { message:"must be given please"}
  
  has_rich_text :content
  has_one_attached :thumbnail, dependent: :destroy
  
  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy

  acts_as_votable

  enum status: {
    new_created: 0,
    approved: 1,
    rejected: 2
  }

  scope :filter_by_categories, ->(categories_id){
    where "post_categories.category_id in (#{categories_id.join(',')})"
  }
  scope :search_by, ->(post_title){
    approved
    .joins(:post_categories)
    .where(["lower(title) like ?","%#{post_title.downcase}%"])
    .order(updated_at: :desc) 
  }
  scope :new_posts, ->{
    approved
    .includes(:post_categories)
    .order(updated_at: :desc)
  }
  scope :top_rating, ->{
    approved
    .includes(:post_categories)
    .order(updated_at: :desc)
    .sort_by {|post| post.average_score}.reverse
  }
  scope :most_reading, ->{
    approved
    .includes(:post_categories)
    .order(updated_at: :desc)
    .order(read_count: :desc)
  }

  def average_score
    result = self.rates.average(:score)
    result ||= 0
  end

  def rate_by_user_with_score current_user, score 
    self.rates.find_by(user_id: current_user.id).update(score: score)
  end
  
  def reading_time
    words_per_minute = 150
    text = ActionController::Base.helpers.strip_tags(self.content.body.to_s)
    time = text.split.length / words_per_minute
    time > 0 ? time : 1
  end

  def text_content
    body = self.content.body.html_safe
    
    text = ""
    document = Nokogiri::HTML.parse(body)
    document.css('br').each {|e| e.replace "\n" }

    document.css('a').each do |e| 
      e.content += " (#{e['href']}) "
      puts e['href']
    end

    document.css('div,pre').each do |e| 
      e.content += "\n"
    end
    
    document.css('li').each do |e| 
      e.content = "- #{e.content} \n"
    end

    document.text
  end

end
