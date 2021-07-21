
class Dashboard::PostsController < Dashboard::BaseController
  before_action :authenticate_user!, except: %i[show search]
  before_action :check_user, except: %i[show search]
  before_action :set_post, only: %i[show edit update destroy approve_post reject_post like dislike rate read_count]
  skip_before_action :verify_authenticity_token, :authenticate_user!, only: %i[read_count]
  
  include Rails.application.routes.url_helpers

  def index
    @posts = current_user.posts.order("updated_at desc")
  end

  def show
    authorize @post 
    @comment_paginate = @post.comments.order(created_at: :desc)
    @related_posts = @post.related_posts
    @more_from_author_posts = @post.more_from_author_posts

    respond_to do |format|
      format.html
      format.js {render partial:'dashboard/posts/js_erb/show.js.erb'}
    end 
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)
    # thêm categories vào post
    categories_id = params[:post][:categories_id].select{|item| item.present?} 
    categories = Category.where(id:categories_id)
    @post.categories = categories 
    
    if @post.save      
      @post.update(post_facebook?: true) if params[:post_facebook]
      PostMailer.create_post(current_user, @post).deliver_later
      
      redirect_to @post, notice: "Post was successfully created." 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def update
    # add categories 
    categories_id = params[:post][:categories_id].select{|item| item.present?}
    categories = Category.where(id:categories_id)
    @post.categories = categories

    if @post.update(post_params)
      if @post.approved? && @post.post_facebook_id != ''
        Graph.put_object(@post.post_facebook_id, '', {
          message: @post.text_content
        })
      end
      
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity 
    end
  end
  
  def destroy
    unless @post.post_facebook_id.empty?
      Graph.delete_object @post.post_facebook_id
    end
    @post.destroy
    redirect_to dashboard_posts_path, notice: "Post was successfully destroyed." 
  end

  # Cho phép admin approved
  def approve_post
    authorize @post
    @post.approved!
    @post.status_change_at = DateTime.now 
    
    if @post.save 
      PostMailer.approved_post(current_user, @post).deliver_later
      respond_to do |format|
        format.html
        format.js { render partial:"dashboard/posts/js_erb/approve_post.js.erb" }
      end

      if @post.post_facebook?
        object = Graph.put_object('me', 'feed', {
          message: @post.text_content,
          link: post_url(@post)
        })

        @post.update post_facebook_id: object['id']
      end
    else
      redirect_back fallback_location:root_path, alert: "Approve post fail"
    end
  end

  # Cho phép admin rejected
  def reject_post
    authorize @post
    @post.rejected!
    @post.status_change_at = DateTime.now 

    if @post.save 
      PostMailer.rejected_post(current_user, @post).deliver_later
      respond_to do |format|
        format.html
        format.js { render partial:"dashboard/posts/js_erb/reject_post.js.erb" }
      end
    else
      redirect_back fallback_location:root_path, alert: "Reject post fail"
    end
  end

  # Chức năng search
  def search
    post_title = params[:post_title] ? params[:post_title].split(' ').join("%") : ''
    categories_id = params[:categories_id] ? params[:categories_id].select{|i| not i.blank?} : []
    
    @categories = Category.search_by categories_id
    @posts = Post.search_by post_title
    @posts = categories_id.empty? ? @posts : @posts.filter_by_categories(categories_id)
  end

  # update read count by visitors
  def read_count
    @post.visits.create
  end

  # toogle like
  def like 
    like = current_user.get_likeable @post 
    if like 
      if @post.user.id != current_user.id
        notification = Notification.find_by notifiable: like
        ActionCable.server.broadcast "notifications:#{@post.user.id}", {
          action:'remove', 
          notification:notification
        } 
        notification.destroy 
      end
      like.destroy
    else 
      created_like = current_user.likes.create(likeable: @post)
      if @post.user.id != current_user.id
        notification = Notification.create(
          notifiable: created_like,
          message:"like your post: #{@post.title}", 
          link: post_path(@post),
          sender: current_user,
          recipient: @post.user 
        )
        html_header = ApplicationController.render(
          partial: 'shared/notification_item',
          locals: { notification: notification }
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
    end
    render partial:"dashboard/posts/js_erb/like.js.erb" 
  end
  
  def rate 
    score = params[:score]
    unless current_user.get_rate_with @post
      @rate = @post.rates.build(score: score)
      @rate.user = current_user 
      @rate.save 
    else
      @post.rate_by_user_with_score current_user, score
      @post.save
    end
    render partial:"dashboard/posts/js_erb/rate.js.erb"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by(id:params[:id])
      unless @post.present?
        return redirect_back fallback_location: root_path, alert: "Post not found"
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title,:content,:thumbnail,:short_description)
    end
end
