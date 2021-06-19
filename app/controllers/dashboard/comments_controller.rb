class Dashboard::CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_post 
  before_action :authenticate_user!

  def new
    # @comment = @post.comments.build
  end
  
  def create
    # Lúc này comment mới chỉ thuộc về post, ta cần thêm ràng buộc với user tạo comment
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user  

    respond_to do |format|
      unless @comment.save
        flash[:alert] = "Fail to add comment" 
      end
      format.js
      format.html
      # redirect_back(fallback_location:root_path)
    end
  end
  
  def edit
  end
  
  def update
    unless @comment.update comment_params
      flash[:alert] = "Fail to update comment"
    end
    redirect_to post_path(@post)
  end
  
  def destroy
    @comment.destroy 
    redirect_to post_path(@post)
  end

  def set_post
    @post = Post.find_by(id: params[:post_id])
    unless @post.present?
      flash[:info] = "Not found Post"
      redirect_back fallback_location: root_path
    end
  end

  private
    def set_comment
      @comment = @post.comments.find_by(id: params[:id])
      unless @comment.present?
        flash[:info] = "Not found comment"
        redirect_back fallback_location: root_path
      end
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
  
end
