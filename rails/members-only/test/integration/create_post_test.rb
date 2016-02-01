require 'test_helper'

class CreatePostTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jrmole)
  end

  def test_can_create_post_if_logged_in
    log_in_as(@user)
    assert_difference('Post.count', 1) do
      post_via_redirect posts_url post: {text: "lorem ipsum dolor sit amet..."}
    end
    assert_template 'index'
  end

  def test_cannot_create_post_unless_logged_in
    assert_no_difference('Post.count') do
      post_via_redirect posts_url post: {text: "lorem ipsum dolor sit amet..."}
    end
    assert_template 'sessions/new'
  end

  def test_render_new_if_create_fails
    log_in_as(@user)
    assert_no_difference('Post.count') do
      post_via_redirect posts_url post: {text: ""}
    end
    assert_template 'posts/new'
  end

end
