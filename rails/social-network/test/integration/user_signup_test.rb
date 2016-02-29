require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def setup
    @email = "test@example.com"
  end

  def test_valid_user_signup
    get new_user_registration_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {email: @email, password: "password"}
    end
    assert_template 'users/index'
    assert_match 'successfully', response.body

    my_sign_out
    assert_template 'sessions/new'
  end

  def test_invalid_user_signup
    get new_user_registration_path
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {email: users(:a_user).email, password: "password"} # email must be unique
      post_via_redirect users_path, user: {email: @email, password: ""} # password can't be blank
      post_via_redirect users_path, user: {email: "", password: "password"} # email can't be blank
    end
    assert_match "error prohibited", response.body
  end

end
