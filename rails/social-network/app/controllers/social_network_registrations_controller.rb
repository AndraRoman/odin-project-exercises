class SocialNetworkRegistrationsController < Devise::RegistrationsController

  def create
    super
    if @user.persisted?
      UserMailer.welcome_email(@user).deliver_later
    end
  end

end
