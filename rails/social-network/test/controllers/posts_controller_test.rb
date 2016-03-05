require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @post = posts(:first)
    @user = users(:active)
  end

  def test_get_new
    sign_in @user
    get :new
    assert_response :success
  end

  def test_redirects_new_when_not_logged_in
    get :new
    assert_match "have to be logged in", flash[:danger]
    assert_redirected_to new_user_session_url
  end

  def test_redirects_create_when_not_logged_in
    assert_no_difference 'Post.count' do
      post :create, post: {title: "Title", content: "Content"}
    end
    assert_match "have to be logged in", flash[:danger]
    assert_redirected_to new_user_session_url
  end

  def test_redirects_show_when_not_logged_in
    get :show, id: @post.id
    assert_redirected_to new_user_session_url
  end

  def test_redirects_index_when_not_logged_in
    get :index
    assert_redirected_to new_user_session_url
  end

  def test_redirects_edit_when_not_logged_in
    get :edit, id: @post.id
    assert_redirected_to new_user_session_url
  end

  def test_redirects_edit_when_logged_in_as_wrong_user
    sign_in @user
    get :edit, id: @post.id
    assert_redirected_to @post
  end

  def test_redirects_update_when_not_logged_in
    new_content = "Hacked"
    patch :update, id: @post.id, post: {content: new_content}
    assert_redirected_to new_user_session_url
    refute_match new_content, @post.content
  end

  def test_redirects_update_when_logged_in_as_wrong_user
    sign_in @user
    new_content = "Hacked"
    patch :update, id: @post.id, post: {content: new_content}
    assert_redirected_to @post
    refute_match new_content, @post.content
  end

  def test_redirects_destroy_when_not_logged_in
    assert_no_difference 'Post.count' do
      delete :destroy, id: Post.first.id
    end
    assert_redirected_to new_user_session_url
  end

  def test_redirects_destroy_when_logged_in_as_wrong_user
    sign_in @user
    assert_no_difference 'Post.count' do
      delete :destroy, id: @post.id
    end
    assert_redirected_to @post
  end

end
