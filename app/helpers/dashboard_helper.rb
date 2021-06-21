module DashboardHelper
  def is_admin
    current_user.role == User::ROLES[:admin]
  end

  def unpublished_paginate posts
    posts.paginate(page: params[:page_unpublished], per_page: 5).order(updated_at: :desc)
  end

  def recently_published_paginate posts
    posts.paginate(page: params[:page_recently_published], per_page: 5).order(updated_at: :desc)
  end
  
end
