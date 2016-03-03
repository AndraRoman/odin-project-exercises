class FriendshipsController < ApplicationController

  before_action :logged_in_user

  def create
    @user = User.find(params[:recipient_id])
    current_user.add_friend(@user)
    flash[:success] = "Successfully sent friend request"
    redirect_to @user
  end

  # don't need other params because there's only one kind of non-destructive change that will ever happen
  def update
    @friendship = Friendship.find(params[:id])
    @user = @friendship.initiator
    current_user.confirm_friend(@user)
    flash[:success] = "Accepted friend request"
    redirect_to @user
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @user = [@friendship.initiator, @friendship.recipient].find {|user| user.id != current_user.id}
    store_location
    current_user.remove_friend(@user)
    flash[:success] = "Successfully removed friend"
    friendly_forward_or_redirect_to(root_path)
  end

end
