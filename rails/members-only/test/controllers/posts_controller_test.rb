require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  def setup
    @user = users(:jrmole)
  end

  def test_new_redirects_if_not_logged_in
    get :new
    assert_redirected_to login_url
  end

  def test_gets_new_if_logged_in
    log_in_as(@user)
    get :new
    assert_response :success
  end

  def test_create_redirects_if_not_logged_in
    post :create, post: {text: "lorem ipsum dolor sit amet..."}
    assert_redirected_to login_url
  end

  def test_gets_create_if_logged_in
    log_in_as(@user)
    assert_difference('Post.count', 1) do
      post :create, post: {text: "lorem ipsum dolor sit amet..."}
    end
  end

end
