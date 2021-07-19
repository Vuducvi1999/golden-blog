class Dashboard::CommentsController < ApplicationController
  before_action :set_post 
  before_action :set_comment, only: %i[update destroy like reply]
  
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
    unless @comment.save 
    flash[:alert] = "Fail to add comment" 
    end

    if @post.user.id != current_user.id 
      notification = Notification.create(
        notifiable: @comment,
        message:"comment your post: #{@post.title}",
        link: post_path(@post),
        sender: current_user,
        recipient: @post.user 
      )
      html_header = ApplicationController.render(
        partial: 'shared/notification_item',
        locals: {notification: notification}
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
    end

    render partial:'dashboard/comments/create.js.erb'
  end
  
  def update 
    flash[:alert] = "Fail to update comment" unless @comment.update(comment_params)
    render partial:'dashboard/comments/update.js.erb' 
  end
  
  def destroy
    @comment.destroy 
    render partial:'dashboard/comments/destroy.js.erb'

  end

  def like
    like = current_user.get_likeable @comment 
    if like 
      like.destroy
    else 
      created_like = current_user.likes.create(likeable: @comment)
      if @comment.user.id != current_user.id
        notification = Notification.create(
          notifiable: created_like,
          message:"like your comment: #{@comment.content}", 
          link: post_path(@post),
          sender: current_user,
          recipient: @comment.user 
        )
        html_header = ApplicationController.render(
          partial: 'shared/notification_item',
          locals: { notification: notification }
        )
        html_toast = ApplicationController.render(
          partial: 'shared/notification_toast',
          locals: {notification: notification}
        )
        ActionCable.server.broadcast "notifications:#{@comment.user.id}", {
          action:'add', 
          html_header:html_header, 
          html_toast:html_toast,
          notification:notification
        } 
      end
    end 
    render partial:"dashboard/comments/js_erb/like.js.erb"
  end

  def reply 
    @reply_comment = @comment.comments.build(comment_params)
    @reply_comment.user = current_user
    
    unless @reply_comment.save 
    flash[:alert] = "Fail to reply comment"
    end 

    if @comment.user.id != current_user.id
      notification = Notification.create(
        notifiable: @reply_comment,
        message:"reply your comment: #{@comment.content}",
        link: post_path(@post),
        sender: current_user,
        recipient: @comment.user 
      )
      html_header = ApplicationController.render(
        partial: 'shared/notification_item',
        locals: { notification: notification }
      )
      html_toast = ApplicationController.render(
        partial: 'shared/notification_toast',
        locals: {notification: notification}
      )
      ActionCable.server.broadcast "notifications:#{@comment.user.id}", {
        action:'add', 
        html_header:html_header, 
        html_toast:html_toast,
        notification:notification 
      } 
    end

    render partial:'dashboard/comments/reply.js.erb'
  end

  private
    def set_comment
      @comment = Comment.find_by(id: params[:id])
      
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
