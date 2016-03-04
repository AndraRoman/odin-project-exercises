require 'test_helper'

class PostCreationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:active)
    my_sign_in @user
  end

  def test_create_invalid_post
    get new_post_path
    assert_template 'posts/new'
    assert_no_difference 'Post.count' do
      post_via_redirect posts_path, post: {title: "", content: ""}
    end
    assert_template 'posts/new'
    assert flash.empty?
    assert_select '#error_messages', count: 1
  end

  def test_create_valid_post
    get new_post_path
    assert_template 'posts/new'
    assert_difference 'Post.count', 1 do
      post_via_redirect posts_path, post: {title: "lorem ipsum", content: "dolor sit amet"}
    end
    refute flash.empty?
    assert_template 'posts/show'
  end

end
