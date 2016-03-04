class PostsController < ApplicationController

  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post successfully created!"
      redirect_to @post
    else
      render :new
    end
  end

  def show
    # TODO
  end

  def index
    # TODO
  end

  def edit
    # TODO
  end

  def update
    # TODO
  end

  def destroy
    # TODO
  end

  private

    def post_params
      params.require(:post).permit(:title, :content)
    end

    def correct_user
      post = Post.find_by(id: params[:id])
      redirect_to post unless post.user.id == current_user.id
    end

end
