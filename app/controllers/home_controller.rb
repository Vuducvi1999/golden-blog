class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index 
    post_all = Post.all.approved.includes(:post_categories, :comments, :rates, :visits)  
    @new_posts = post_all.new_posts 
    @top_rating = post_all.top_rating 
    @most_reading = post_all.most_reading
    @weekly_hostest = post_all.weekly_hostest
    @monthly_hostest = post_all.monthly_hostest
    @yearly_hostest = post_all.yearly_hostest
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
