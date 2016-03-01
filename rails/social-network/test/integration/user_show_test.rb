require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:active_user)
    my_sign_in @user
  end

  def test_404_if_user_not_found
    invalid_user_id = 0
    refute User.find_by(id: invalid_user_id)
    get "/users/#{invalid_user_id}"
    assert_response :missing
  end

  def test_profiles_user
    get "/users/#{@user.id}"
    assert_response :success
  end

end
