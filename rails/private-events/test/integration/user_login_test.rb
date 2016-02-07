require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def test_invalid_login
    get login_path
    post_via_redirect login_path, session: { name: "Fake User" }
    refute is_logged_in?
    refute flash.empty?
    assert_template 'sessions/new'
  end

  def test_valid_login_followed_by_logout
    get login_path
    post_via_redirect login_path, session: { name: "C E Douglass" }
    assert is_logged_in?
    assert flash.empty?
    assert_template 'users/show'

    delete logout_path
    refute is_logged_in?
    assert_template 'sessions/new'
  end

end
