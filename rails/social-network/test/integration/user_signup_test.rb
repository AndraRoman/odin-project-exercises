require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def setup
    @email = "test@example.com"
    @image_path = fixture_path + "files/rails.png"
    @image = fixture_file_upload(@image_path, "image/png")
  end

  def test_valid_user_signup
    get new_user_registration_path
    assert_difference ['User.count', 'ActionMailer::Base.deliveries.size'], 1 do
      post_via_redirect users_path, user: {email: @email, password: "password", name: "A Human", profile_pic: @image}
    end

    user = User.find_by(email: @email)
    assert_equal "rails.png", user.profile_pic_file_name 
    assert_equal "A Human", user.name

    assert_template 'users/index'
    assert_match 'successfully', response.body
    assert_select '.profile_pic', count: 2

    my_sign_out
    assert_template 'sessions/new'
  end

  def test_invalid_user_signup
    get new_user_registration_path
    assert_no_difference ['User.count', 'ActionMailer::Base.deliveries.size'] do
      post_via_redirect users_path, user: {email: users(:active).email, password: "password"} # email must be unique
      post_via_redirect users_path, user: {email: @email, password: ""} # password can't be blank
      post_via_redirect users_path, user: {email: "", password: "password"} # email can't be blank
    end
    assert_match "error prohibited", response.body
  end

end
