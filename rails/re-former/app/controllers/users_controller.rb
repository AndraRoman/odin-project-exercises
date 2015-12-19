class UsersController < ApplicationController

  def new
    @user = User.new
  end

  # create path is same as index path by default, so url changes even if create fails. this is apparently The Rails Way; disconcerting but harmless. could fix routing manually but won't.
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  # update path is same as show path, so url changes even if edit fails
  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes :username => user_params[:username], :email => user_params[:email], :password => user_params[:password]
      render :show
    else
      render :edit
    end
  end

  def show
    id = params[:id]
    @user = User.find_by_id(id)
  end

  private
  
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end
