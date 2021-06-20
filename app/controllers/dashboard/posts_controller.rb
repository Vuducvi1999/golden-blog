
class Dashboard::PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_post, only: %i[ edit update destroy create_comment_post ]
  before_action :comment_params, only: %i[create_comment_post]

  # GET /posts or /posts.json
  def index
    @posts = current_user.posts.order("updated_at desc")
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find_by id:params[:id]
    @page = params[:page]
   
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = current_user.posts.find_by(id: params[:id])
      unless @post.present?
        flash[:alert] = "Not found post"
        redirect_to root_path
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title,:content,:thumbnail,:short_description)
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
