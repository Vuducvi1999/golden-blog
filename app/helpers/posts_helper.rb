module PostsHelper
  def comment_paginate comments
    comments.paginate(page: params[:page], per_page: 10).order(updated_at: :desc)
  end
end
