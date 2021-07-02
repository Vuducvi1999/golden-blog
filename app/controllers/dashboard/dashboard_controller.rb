class Dashboard::DashboardController < Dashboard::BaseController
  def index
  end

  def manage_posts
    new_posts = Post.where(status: Post::STATUS[:new])
    approved_posts = Post.where(status: Post::STATUS[:approved])
    rejected_posts = Post.where(status: Post::STATUS[:rejected])

    @new_posts_paginate = new_posts.paginate(page: params[:page_new_posts], per_page: 10).order(updated_at: :desc)

    @approved_posts_paginate = approved_posts.paginate(page: params[:page_approved_posts], per_page: 10).order(updated_at: :desc)

    @rejected_posts_paginate = rejected_posts.paginate(page: params[:page_rejected_posts], per_page: 10).order(updated_at: :desc)


    respond_to do |format|
      format.html
      format.js {render partial:"dashboard/dashboard/manage_posts.js.erb"}
    end
  end

end