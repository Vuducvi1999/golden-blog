class Dashboard::DashboardController < ApplicationController
  def index
  end

  def manage_posts
    @new_posts = Post.where(status: Post::STATUS[:new])
    @approved_posts = Post.where(status: Post::STATUS[:approved])
    @rejected_posts = Post.where(status: Post::STATUS[:rejected])

    respond_to do |format|
      format.html
      format.js {render partial:"dashboard/dashboard/manage_posts.js.erb"}
    end
  end

end