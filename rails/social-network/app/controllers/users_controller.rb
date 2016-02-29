class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :show]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
    unless @user
      render text: "404 ERROR: Could not find user with ID #{params[:id]}.", status: '404'
    end
  end

end
