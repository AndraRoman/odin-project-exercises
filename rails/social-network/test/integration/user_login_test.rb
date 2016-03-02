require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def test_invalid_login
    get new_user_session_path
    post_via_redirect user_session_path, user: {email: "fake", password: "fake"}
    assert_template 'sessions/new'
    refute is_logged_in?
  end

  # shouldn't really be needed because this is testing Devise's functionality more than mine, but want to see that I can do it anyway
  def test_valid_login_followed_by_logout
    get new_user_session_path
    post_via_redirect user_session_path, user: {email: users(:active).email, password: "password"}
    assert_template 'users/index'
    assert is_logged_in?

    delete_via_redirect destroy_user_session_path
    refute is_logged_in?
    assert_template 'sessions/new'
  end

end
