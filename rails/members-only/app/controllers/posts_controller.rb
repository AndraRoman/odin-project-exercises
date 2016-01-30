class PostsController < ApplicationController

  before_action :user_logged_in?, only: [:new, :create] # synonym for before_filter

  def new
  end

  def show
  end

  def index
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id # won't be nil thanks to before_action filter
    if @post.save
      redirect_to posts_path
    else
      render 'new' # TODO test
    end
  end

  private

  # before filters

  def user_logged_in?
    unless logged_in?
      redirect_to login_url
    end
  end

  def post_params
    params.require(:post).permit(:text)
  end

end
