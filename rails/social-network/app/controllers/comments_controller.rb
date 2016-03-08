class CommentsController < ApplicationController

  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  # TODO test controller
  # TODO test UI
  def create
    @comment = current_user.comments.build(comment_params)
    store_location
    if @comment.save
      flash[:success] = "Comment successfully created!"
    end
    friendly_forward_or_redirect_to(@comment.post)
  end

  # TODO test controller
  # TODO test UI
  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @comment.destroy
    friendly_forward_or_redirect_to(@post) # location set in before_action filter
  end

  private

    def comment_params
      params.require(:comment).permit(:post_id, :content)
    end

    # TODO this is repeated from post controller
    def correct_user
      store_location
      comment = Comment.find_by(id: params[:id])
      friendly_forward_or_redirect_to(comment.post) unless current_user?(comment.user) # TODO do I actually care if this fails when someone tries to delete a comment that doesn't exist?
    end

end
