class UserMailer < ApplicationMailer
  default from: "contact@example.com" 

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to the social network!")
  end  

end
