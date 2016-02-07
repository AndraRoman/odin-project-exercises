class SessionsController < ApplicationController

  def new
  end

  def create
    name = params[:session][:name]
    user = User.find_by(name: name)
    if user
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "We couldn't find an account with that name. Try again or sign up as a new user."
      render 'new'
    end
  end

  # no root url to redirect to - just go back to login view
  def destroy
    log_out
    render 'new'
  end

end
