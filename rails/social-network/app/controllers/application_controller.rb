class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logged_in_user
    unless user_signed_in? # devise helper method
      flash[:danger] = "You have to be logged in to do that." # TODO friendly forwarding
      redirect_to new_user_session_path
    end
  end

  private

    def after_sign_out_path_for(user)
      root_path
    end

end
