class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index 
    post = Post.all.approved.includes(:post_categories)  
    @new_posts = post.new_posts 
    @top_rating = post.top_rating 
    @most_reading = post.most_reading
    
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
