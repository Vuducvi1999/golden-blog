module PostsHelper
  def comment_paginate comments
    comments.paginate(page: params[:page], per_page: 10).order(updated_at: :desc)
  end

  def is_admin
    current_user.present? && current_user.role == User::ROLES[:admin]
  end

  def is_author
    current_user.present? && current_user.id == @post.user.id
  end

  def is_approved
    @post.status == Post::STATUS[:approved]
  end
end
