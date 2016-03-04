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
    @post = Post.find_by(id: params[:id])
    unless @post
      render text: "404 ERROR: Could not find post with ID #{params[:id]}.", status: "404"
    end
  end

  def index
    # TODO
  end

  def edit
    @post = Post.find_by(id: params[:id])
    unless @post
      render text: "404 ERROR: Could not find post with ID #{params[:id]}.", status: "404"
    end
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Post successfully updated!"
      redirect_to @post
    else
      render :edit
    end
 end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to root_url
  end

  private

    def post_params
      params.require(:post).permit(:title, :content)
    end

    def correct_user
      post = Post.find_by(id: params[:id])
      redirect_to post unless current_user?(post.user)
    end

end
