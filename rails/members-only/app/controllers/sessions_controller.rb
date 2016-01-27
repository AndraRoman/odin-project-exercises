class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_name(params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id # log user in
      redirect_to(user)
    else
      render 'new'
    end
  end

end
