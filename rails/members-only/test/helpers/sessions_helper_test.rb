require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @user = User.new(name:  "M. plicatulus",
                     email: "User@example.com",
                     password: "password",
                     password_confirmation: "password")
    @user.save
    remember(@user)
  end

  def test_current_user_works_when_session_nil
    assert_equal(@user, current_user)
  end

  def test_current_user_nil_when_token_doesnt_match
    cookies.permanent['remember_token'] = "253523"
    refute(current_user)
  end

end
