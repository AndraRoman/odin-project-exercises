class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logged_in_user
    unless user_signed_in? # devise helper method
      flash[:danger] = "You have to be logged in to do that."
      store_location
      redirect_to new_user_session_path
    end
  end


  def store_location
    if request.get?
      session[:forward_url] = request.url
    else
      session[:forward_url] = request.referrer
    end
  end

  def friendly_forward_or_redirect_to(default_path)
    redirect_to(session[:forward_url] || default_path)
    session.delete(:forward_url)
  end

  private

    def after_sign_out_path_for(user)
      root_path
    end

    def after_sign_in_path_for(user)
      session[:forward_url] ? session.delete(:forward_url) : super # delete returns its argument
    end

end
