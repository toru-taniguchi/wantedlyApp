class PostsController < ApplicationController
  PER = 4
  # before_action :authenticate_company!, except: [:index]
  def index
    @posts = Post.page(params[:page]).per(PER)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.company_id = current_company.id
    @post.save
    redirect_to posts_path
  end

  def edit
    @post = Post.find(params[:id])
    @post.company_id = current_company.id
  end
  
  def show
    @post = Post.find(params[:id])
    @company = @post.company


    @user_comment = UserComment.new
    @user_comments = @post.user_comments.to_a
    @company_comment = CompanyComment.new
    @company_comments = @post.company_comments.to_a

    @comments = []
    @comments = @user_comments + @company_comments
    @comments = @comments.sort_by {|x| x[1]}.reverse
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to root_path
  end

  private

    def post_params
      params.require(:post).permit(:image, :title, :content)
    end
  
end