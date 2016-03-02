class FriendshipsController < ApplicationController

  def create
    @user = User.find(params[:recipient_id])
    current_user.add_friend(@user) # TODO not really sure why there was a build in the form when we're not creating anything directly - review
    render @user
    # TODO flash message
  end

  def destroy
    @user = User.find(params[:recipient_id])
    current_user.remove_friend(@user)
    redirect_to root_path # TODO friendly forwarding
  end

end
