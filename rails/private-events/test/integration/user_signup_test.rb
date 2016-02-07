require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def test_signup_with_invalid_name
    get signup_path
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: { name: " " }
    end
    assert_template 'users/new'
    refute flash.empty?
    refute is_logged_in?
  end

  def test_valid_signup
    name = "A New User"
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: name }
    end
    assert is_logged_in?
    assert flash.empty?
    assert_template 'users/show'
  end

end
