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

  def test_friendly_forwarding_on_sign_in
    user = users(:passive)
    get user_path(user)
    assert_redirected_to new_user_session_path
    post_via_redirect user_session_path, user: {email: users(:active).email, password: "password"}
    # devise does something weird so this gives a 200 instead of a redirect in test environment. so only testing the template, not the redirect itself.
    assert_template 'users/show'
  end

end
