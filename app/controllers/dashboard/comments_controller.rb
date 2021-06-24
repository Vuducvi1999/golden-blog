class Dashboard::CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]
  before_action :set_post 
  
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
     unless @comment.save 
      flash[:alert] = "Fail to add comment"
     end
    
    respond_to do |format|
      format.html {redirect_to post_path(@post)}
      format.js {render partial:'dashboard/comments/create.js.erb'}
    end
  end
  
  def update    
    flash[:alert] = "Fail to update comment" unless @comment.update(comment_params)
    redirect_to post_path(@post)
  end
  
  def destroy
    @comment.destroy 
    redirect_to post_path(@post)
  end

  private
    def set_comment
      @comment = @post.comments.find_by(id: params[:id])
      
      unless @comment.present?
        flash[:info] = "Not found comment"
        return redirect_back fallback_location: root_path
      end
    end

    def set_post
      @post = Post.find_by(id: params[:post_id])

      unless @post.present?
        flash[:info] = "Not found Post"
        return redirect_back fallback_location: root_path
      end
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
  
end
