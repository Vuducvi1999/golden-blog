module PostsHelper
  def comment_paginate comments
    comments.paginate(page: params[:page], per_page: 5).order(updated_at: :desc)
  end
end
