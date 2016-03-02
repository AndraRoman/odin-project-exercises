require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @user = users(:active)
    @second_user = users(:passive)
  end

  def test_index_requires_login
    get :index
    assert_redirected_to new_user_session_path
  end

  def test_show_requires_login
    get :show, {id: @user.id}
    assert_redirected_to new_user_session_path
  end

  def test_show_succeeds
    sign_in @user
    get :show, {id: @user.id} # can get own profile
    assert_response :success

    get :show, {id: @second_user.id} # can get own profile
    assert_response :success
  end

  def test_index_succeeds
    sign_in @user
    get :index
    assert_response :success
  end

end
