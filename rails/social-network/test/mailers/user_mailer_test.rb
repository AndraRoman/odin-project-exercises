require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper


  # allow to compare dynamic data in email using erb
  def read_fixture(action)
    x = super
    template = ERB.new(x.join)
    template.result(binding)
  end

  def setup
    @email = "new_user_email@example.com"
    @name = "New User"
    @id = 1000
    @user = User.new(id: @id, name: @name, email: @email, password: "password")
    @user.save
  end

  def test_welcome
    email = UserMailer.welcome_email(@user).deliver_now

    refute ActionMailer::Base.deliveries.empty?

    assert_equal [@email], email.to
    assert_equal ['contact@example.com'], email.from
    assert_equal 'Welcome to the social network!', email.subject

    assert_equal read_fixture('welcome.txt.erb'), email.text_part.body.to_s
    assert_equal read_fixture('welcome.html.erb'), email.html_part.body.to_s
  end

end
