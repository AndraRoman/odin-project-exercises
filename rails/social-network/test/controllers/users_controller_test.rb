require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def test_index_requires_login
    get :index
    assert_redirected_to new_user_session_path
  end

  def test_show_requires_login
    user = users(:a_user)
    get :show, {id: user.id}
    assert_redirected_to new_user_session_path
  end

  def test_show_succeeds
    user = users(:a_user)
    sign_in user
    get :show, {id: user.id}
    assert_response :success
  end

  def test_index_succeeds
    user = users(:a_user)
    sign_in user
    get :index
    assert_response :success
  end

end
