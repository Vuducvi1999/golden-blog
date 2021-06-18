
  class Dashboard::PostsController < ApplicationController
    before_action :authenticate_user!, except: %i[show]
    before_action :set_post, only: %i[ edit update destroy ]
  
  
    # GET /posts or /posts.json
    def index
      @posts = current_user.posts
    end
  
    # GET /posts/1 or /posts/1.json
    def show
      @post = Post.find params[:id]
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
        format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_post
        @post = current_user.posts.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def post_params
        params.require(:post).permit(:title,:content,:thumbnail,:short_description)
      end
  end
