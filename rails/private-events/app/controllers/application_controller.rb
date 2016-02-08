class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def logged_in_user
    unless logged_in?
      flash[:danger] = "You have to be logged in to do that." # later friendly forwarding
      redirect_to login_url
    end
  end

end
