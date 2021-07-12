class Dashboard::CommentsController < ApplicationController
  before_action :set_post 
  before_action :set_comment, only: %i[update destroy]
  
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
    unless @comment.save 
    flash[:alert] = "Fail to add comment"
    end

    notification = Notification.create(
      message:"comment your post: #{@post.title}",
      link: post_path(@post),
      sender: current_user,
      recipient: @post.user 
    )
    html_header = ApplicationController.render(
      partial: 'shared/notification_item',
      locals: { item: notification }
    )
    html_toast = ApplicationController.render(
      partial: 'shared/notification_toast',
      locals: {notification: notification}
    )
    ActionCable.server.broadcast "notifications:#{@post.user.id}", {
      action:'add', 
      html_header:html_header, 
      html_toast:html_toast,
      notification:notification
    } 

    render partial:'dashboard/comments/create.js.erb'
  end
  
  def update    
    flash[:alert] = "Fail to update comment" unless @comment.update(comment_params)
    render partial:'dashboard/comments/update.js.erb' 
  end
  
  def destroy
    @comment.destroy 

    notification = Notification.find_by(
      message:"comment your post: #{@post.title}",
      sender: current_user,
      recipient: @post.user 
    )
    notification.destroy
    ActionCable.server.broadcast "notifications:#{@post.user.id}", {action:'remove', notification:notification}

    render partial:'dashboard/comments/destroy.js.erb', locals: {comment: @comment}
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
