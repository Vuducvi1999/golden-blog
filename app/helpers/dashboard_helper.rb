module DashboardHelper
  def is_admin
    current_user.role == User::ROLES[:admin]
  end

  def new_posts_paginate posts
    posts.paginate(page: params[:page_new_posts], per_page: 10).order(updated_at: :desc)
  end

  def approved_posts_paginate posts
    posts.paginate(page: params[:page_approved_posts], per_page: 10).order(updated_at: :desc)
  end

  def rejected_posts_paginate posts
    posts.paginate(page: params[:page_rejected_posts], per_page: 10).order(updated_at: :desc)
  end
  
end
