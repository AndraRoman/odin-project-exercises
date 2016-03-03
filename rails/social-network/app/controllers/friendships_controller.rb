class FriendshipsController < ApplicationController

  def create
    @user = User.find(params[:recipient_id])
    current_user.add_friend(@user) # TODO not really sure why there was a build in the form when we're not creating anything directly - review
    flash[:success] = "Successfully sent friend request"
    render @user
  end

  # don't need other params because there's only one kind of non-destructive change that will ever happen
  def update
    @user = User.find(params[:id])
    current_user.confirm_friend(@user)
    flash[:success] = "Accepted friend request"
    render @user
  end

  def destroy
    @user = User.find(params[:id])
    current_user.remove_friend(@user)
    flash[:success] = "Successfully removed friend"
    redirect_to root_path # TODO friendly forwarding
  end

end
