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
  has_many :visits, dependent: :destroy

  acts_as_votable 

  enum status: {
    new_created: 0,
    approved: 1,
    rejected: 2
  }
  
  scope :all_includes, -> { approved.includes(:categories, :post_categories, :comments, :rates, :visits) }

  scope :filter_by_categories, ->(categories_id){
    where "post_categories.category_id in (#{categories_id.join(',')})"
  }
  scope :search_by, ->(post_title){
    approved
    .joins(:post_categories)
    .where(["lower(title) like ?","%#{post_title.downcase}%"])
    .order('created_at DESC') 
  }
  scope :new_posts, ->{
    order('created_at DESC')
  }
  scope :top_rating, ->{
    sort_by {|post| post.average_score}.reverse 
    .sort_by {|post| post.created_at}.reverse 
  }
  scope :most_reading, ->{
    sort_by {|post| post.read_count }.reverse 
    .sort_by {|post| post.created_at}.reverse 
  }
  scope :weekly_hostest, ->{
    where(visits: {created_at: DateTime.now.beginning_of_week..DateTime.now.end_of_week})
    .sort_by {|post| post.weekly_read_count }.reverse 
  }
  scope :monthly_hostest, ->{
    where(visits: {created_at: DateTime.now.beginning_of_month..DateTime.now.end_of_month}) 
    .sort_by {|post| post.monthly_read_count }.reverse 
  }
  scope :yearly_hostest, ->{
    where(visits: {created_at: DateTime.now.beginning_of_year..DateTime.now.end_of_year}) 
    .sort_by {|post| post.yearly_read_count }.reverse 
  }

  def average_score
    result = self.rates.average(:score)
    result ||= 0 
  end 

  def read_count
    self.visits.count
  end
  
  def weekly_read_count
    self.visits.where(created_at: DateTime.now.beginning_of_week..DateTime.now.end_of_week).count
  end
  
  def monthly_read_count
    self.visits.where(created_at: DateTime.now.beginning_of_month..DateTime.now.end_of_month).count
  end

  def yearly_read_count
    self.visits.where(created_at: DateTime.now.beginning_of_year..DateTime.now.end_of_year).count
  end

  def rate_by_user_with_score current_user, score 
    self.rates.find_by(user_id: current_user.id).update(score: score)
  end

  def related_posts
    post_categories = self.categories.pluck(:id)

    related_by_categories = Post.all_includes
    .where(post_categories: {category_id: post_categories}).limit(5)
    
    sort_by_reading = related_by_categories.sort_by {|post| post.read_count }
    sort_by_categories = sort_by_reading.sort_by {|post| post.categories.pluck(:id).intersection(post_categories).count }
    sort_by_categories.reverse
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
