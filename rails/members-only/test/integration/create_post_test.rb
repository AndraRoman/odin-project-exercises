require 'test_helper'

class CreatePostTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jrmole)
  end

  def test_gets_create_if_logged_in
    log_in_as(@user)
    assert_difference('Post.count', 1) do
      post_via_redirect posts_url post: {text: "lorem ipsum dolor sit amet..."}
    end
    assert_template 'index'
  end

end
