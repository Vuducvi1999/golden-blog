class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @posts = Post.where(status: Post::STATUS[:approved]) 
  end

  def contact
  end

  def sample_post
  end

  def about
  end
  
end
