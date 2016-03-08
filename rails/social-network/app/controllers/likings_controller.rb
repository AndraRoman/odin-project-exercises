class LikingsController < ApplicationController

  before_action :logged_in_user

  def create
    @post = Post.find(params[:post_id])
    @like = Liking.new(user: current_user, post: @post)
    store_location
    if @like.save
      flash[:success] = "Liked post"
    else
      flash[:danger] = "Couldn't like this post."
    end
    friendly_forward_or_redirect_to(root_path)
  end

  def destroy
    @like = Liking.find_by(id: params[:id])
    store_location
    if @like && current_user?(@like.user)
      @like.destroy
      flash[:success] = "Unliked post"
    else
      flash[:danger] = "Couldn't unlike this post."
    end
    friendly_forward_or_redirect_to(root_path)
  end

end
