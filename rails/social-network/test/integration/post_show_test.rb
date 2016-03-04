require 'test_helper'

class PostShowTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:first)
    @author = @post.user
    @user = users(:active)
  end

  def test_display_for_author
    my_sign_in @author
    get post_path(@post)
    assert_select "a[href=?]", user_path(@author), count: 1
    assert_select ".post-title", text: @post.title, count: 1
    assert_select ".post-content", text: @post.content, count: 1

    assert_select "a[href=?]", edit_post_path(@post), count: 1
    assert_select "a", text: "Delete", count: 1
  end

  def test_display_for_other_user
    my_sign_in @user
    get post_path(@post)
    assert_select "a[href=?]", user_path(@author), count: 1
    assert_select ".post-title", text: @post.title, count: 1
    assert_select ".post-content", text: @post.content, count: 1

    assert_select "a[href=?]", edit_post_path(@post), count: 0
    assert_select "a", text: "Delete", count: 0
  end

end
