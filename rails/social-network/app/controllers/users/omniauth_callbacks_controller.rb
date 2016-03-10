class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # mostly copied straight https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      if User.find_by(email: @user.email) # email already taken
        flash[:danger] = "The email #{@user.email} is already taken."
      elsif !@user.email
        flash[:danger] = "Sorry, your email address is missing. Check that you've confirmed your email address with the authentication provider and given our app permissions."
      end
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to new_user_session_path
  end

end
