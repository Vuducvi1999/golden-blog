class Dashboard::DashboardController < ApplicationController
  before_action :set_post, only: %i[publish_post]
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