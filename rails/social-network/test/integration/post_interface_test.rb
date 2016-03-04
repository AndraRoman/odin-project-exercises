require 'test_helper'

class PostInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:first)
    @user = @post.user
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

  def test_update_post
    get edit_post_path(@post)
    assert_response :success
    assert_template 'posts/edit'
    patch post_path(@post), post: {content: "new text goes here"}

    assert_redirected_to @post
    follow_redirect!
    refute flash.empty?
    assert_match "new text goes here", response.body
  end

  def test_delete_post
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
    refute flash.empty?
    assert_redirected_to root_path
  end

end
