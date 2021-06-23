
class Dashboard::PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[show search]
  before_action :set_post, only: %i[show edit update destroy approve_post reject_post ]
  before_action :check_post_status, only: %i[show]
  before_action :check_admin_to_change_status, only: %i[approve_post reject_post]

  def index
    @posts = current_user.posts.order("updated_at desc")
  end

  def show
    respond_to do |format|
      format.html
      format.js {render partial:'dashboard/posts/show.js.erb'}
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
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity 
    end
  end
  
  def destroy
    @post.destroy
    redirect_to dashboard_posts_path, notice: "Post was successfully destroyed." 
  end

  # Cho phép admin approved
  def approve_post
    @post.status = Post::STATUS[:approved]
    @post.status_change_at = DateTime.now 
    
    if @post.save 
      respond_to do |format|
        format.html
        format.js { render partial:"dashboard/posts/approve_post.js.erb" }
      end
    else
      redirect_back fallback_location:root_path, alert: "Approve post fail"
    end
  end

  # Cho phép admin rejected
  def reject_post
    @post.status = Post::STATUS[:rejected]
    @post.status_change_at = DateTime.now

    if @post.save 
      respond_to do |format|
        format.html
        format.js { render partial:"dashboard/posts/reject_post.js.erb" }
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
    
    # kiểm tra status post và redirect nếu truy cập không hợp lệ
    def check_post_status
      @post = Post.find_by id:params[:id]

      if is_new_post
        return condition_post_if_status_is 'new'
      elsif is_rejected_post
        return condition_post_if_status_is 'rejected'
      end
    end

    def condition_post_if_status_is status
      # nếu người dùng đã đăng nhập và là tác giả hoặc admin thì tiếp tục process
      return if current_user && (is_admin || is_author)
      # nếu không thì redirect và alert
      return status=="new" ? message_and_redirect_if_post_is_new : message_and_redirect_if_post_is_rejected
    end

    def message_and_redirect_if_post_is_new
      flash[:info] = "This post is being process by admin to approve!"
      return redirect_back fallback_location:root_path  
    end
    
    def message_and_redirect_if_post_is_rejected
      flash[:info] = "This post was rejected by admin!"
      return redirect_back fallback_location:root_path  
    end

    def message_and_redirect_if_user_not_admin
      flash[:info] = "Only admin can approve post!"
      return redirect_back fallback_location:root_path  
    end

    # kiểm tra người change status có phải là admin hay không
    def check_admin_to_change_status
      @post = Post.find_by id:params[:id]
      return message_and_redirect_if_user_not_admin unless current_user || is_admin
      return
    end
end
