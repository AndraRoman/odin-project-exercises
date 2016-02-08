class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = "You need to enter a name that nobody else has used."
      render 'new'
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    @events = @user.events
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

end
