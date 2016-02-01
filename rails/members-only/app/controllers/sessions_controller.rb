class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by_name(params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_to '/posts' # '/' is necessary
    else
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    render 'new' # just to avoid errors
  end

end
