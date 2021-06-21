class Dashboard::CommentsController < ApplicationController
  before_action :authenticate!
  skip_before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_post 

  def new
    # @comment = @post.comments.build
  end
  
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      unless @comment.save
        flash[:alert] = "Fail to add comment" 
        format.html {redirect_to @post }
        format.js {render partial:"dashboard/comments/create.js.erb"}
      else
        format.html {redirect_to @post }
        format.js {render partial:"dashboard/comments/create.js.erb"}
      end
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

  def authenticate!
    # kiểm tra user login
    if current_user.present?
      return false
    else
      flash[:alert] = "Please login to comment"
      return redirect_to new_user_session_path
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
