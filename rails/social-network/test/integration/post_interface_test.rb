require 'test_helper'

class PostInterfaceTest < ActionDispatch::IntegrationTest

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

  def test_delete_post
    @post = posts(:first)
    my_sign_out
    my_sign_in @post.user

    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
    refute flash.empty?
    assert_redirected_to root_path
  end

end
