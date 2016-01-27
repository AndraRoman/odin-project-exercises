class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def log_in(user)
    session[:user_id] = user.id
    user.remember # remember_token associated, remember_digest saved to db
    cookies.permanent[:remember_token] = user.remember_token
    current_user=(user)
  end

  # this is sort of setting as well as getting. not sure what's intended here.
  def current_user
    if (user_id = session[:user_id])
      self.current_user ||= User.find(user_id) # assigns and returns @current_user
    elsif (remember_digest = User.digest(cookies.permanent[:remember_token].to_s))
      user = User.find_by(remember_digest: remember_digest)
      log_in user
      self.current_user ||= user
    else
      nil
    end
  end

  def current_user=(user)
    self.current_user = user
  end

end
