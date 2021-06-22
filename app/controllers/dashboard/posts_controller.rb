
class Dashboard::PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[show search]
  before_action :set_post, only: %i[edit update destroy publish_post unpublish_post ]
  before_action :check_post_published, only: %i[show]
  before_action :check_admin_to_publish, only: %i[publish_post unpublish_post]

  # GET /posts or /posts.json
  def index
    @posts = current_user.posts.order("updated_at desc")
  end

  # GET /posts/1 or /posts/1.json
  def show    
    respond_to do |format|
      unless @post.present?
        flash[:alert] = "Not found post"
        format.html {redirect_to root_path}   
        format.js {render partial:'dashboard/posts/show.js.erb'}
      end
      format.html 
      format.js {render partial:'dashboard/posts/show.js.erb'}
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)
    # kiểm tra nếu không có category thì báo lỗi 
    # Nếu có categories thì thêm vào post
    categories_id = params[:post][:categories_id].select{|item| item.present?}
    categories = Category.where(id:categories_id)
    @post.categories = categories 
    
    respond_to do |format|
      if @post.save
        puts current_user.posts.last.categories.pluck(:name)
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        # nếu update thành công thì add categories, có thể add categories trước cũng được
        # nhưng lỡ lủng thì lỡ update categories trong post rồi nên không revert lại được
        categories_id = params[:post][:categories_id].select{|item| item.present?}
        categories = Category.where(id:categories_id)
        @post.categories = categories
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_posts_path, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Cho phép admin publish
  def publish_post
    @post.published = true
    @post.published_at = DateTime.now 

    respond_to do |format|
      if @post.save 
        format.html { redirect_back fallback_location:root_path }
        format.js { render partial:"dashboard/dashboard/publish_post.js.erb" }
      else
        redirect_back fallback_location: root_path
      end
    end
  end
  # Cho phép admin unpublish
  def unpublish_post
    @post.published = false
    @post.published_at = nil 

    respond_to do |format|
      if @post.save 
        format.html { redirect_back fallback_location:root_path }
        format.js { render partial:"dashboard/dashboard/unpublish_post.js.erb" }
      else
        redirect_back fallback_location: root_path
      end
    end
  end

  # Chức năng search
  def search
    post_title = params[:post_title] ? params[:post_title].split(' ').join("%") : ''
    categories_id = params[:categories_id] ? params[:categories_id].select{|i| not i.blank?} : []
    @categories = Category.where(id: categories_id).pluck(:id, :name)

    @posts = Post.joins(:post_categories) 
              .where(["lower(title) like ?","%#{post_title.downcase}%"])
              .order(updated_at: :desc)
    @posts = categories_id.empty? ? @posts : @posts.where("post_categories.category_id in (#{categories_id.join(',')})")

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by(id:params[:id]).includes(:categories)
      unless @post.present?
        flash[:alert] = "Post not found"
        redirect_back fallback_location: root_path
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title,:content,:thumbnail,:short_description)
    end
    
    # kiểm tra published và redirect nếu cần thiết
    def check_post_published
      @post = Post.find_by id:params[:id]

      if @post.published == false 
        if current_user.present? == false
          flash[:info] = "This post is being process by admin to publish!"
          return redirect_back fallback_location:root_path
        elsif current_user.role == User::ROLES[:admin]
          return 
        elsif current_user.id != @post.user.id 
          flash[:info] = "This post is being process by admin to publish!"
          return redirect_back fallback_location:root_path  
        end
      end
    end

    def message_and_redirect_if_post_unpublished
      flash[:info] = "This post is being process by admin to publish!"
      return redirect_back fallback_location:root_path  
    end

    def message_and_redirect_if_user_not_admin
      flash[:info] = "Only admin can publish post!"
      return redirect_back fallback_location:root_path  
    end

    # kiểm tra người publish, unpublish có phải là admin hay không
    def check_admin_to_publish
      @post = Post.find_by id:params[:id]
      if not current_user.present? || current_user.role != User::ROLES[:admin]
        return message_and_redirect_if_user_not_admin
      end
    end
end
