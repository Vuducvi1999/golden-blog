class Dashboard::DashboardController < ApplicationController
  def index
  end

  def manage_posts
    @unpublished = Post.where(published: false)
    @recently_published = Post.where(published: true)

    respond_to do |format|
      format.html
      format.js {render partial:"dashboard/dashboard/manage_posts.js.erb"}
    end
  end
end