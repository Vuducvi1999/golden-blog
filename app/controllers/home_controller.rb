class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index 
    filter = (params[:filter] ||= 'new_posts')
    case filter 
    when 'new_posts'
      @posts = Post.new_posts
    when 'top_rating'
      @posts = Post.top_rating
    when 'most_reading'
      @posts = Post.most_reading
    end
  end

  def contact
  end

  def sample_post
  end

  def about
  end

  def privacy
  end
  
end
