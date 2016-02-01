require 'test_helper'

class UserLoginTestTest < ActionDispatch::IntegrationTest

  # creating a user instead of using one from fixture because bcrypt is using a different hash function here so digests don't match otherwise
  def setup
    @user = users(:jrmole)
  end

  def test_unsuccessful_login
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: " ", password: " "}
    assert_template 'sessions/new'
    refute(is_logged_in?)
  end

  def test_successful_login_followed_by_logout
    get login_path
    log_in_as(@user)
    assert(@user.authenticate("password"))
    assert(is_logged_in?)
    assert_template 'posts/index'

    delete logout_path
    refute(is_logged_in?)

    delete logout_path # confirm double logout doesn't raise error
  end

end
