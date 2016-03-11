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
    assert_select ".post" do
      assert_select "a[href=?]", user_path(@author), count: 1
      assert_select ".post-title", text: @post.title, count: 1
      assert_select ".post-content", text: @post.content, count: 1
      assert_match @post.created_at.to_s, response.body
      assert_select ".like-count", text: '0 likes', count: 1

      assert_select "a[href=?]", edit_post_path(@post), count: 1
      assert_select "a", text: "Delete post", count: 1

      assert_select 'input[value="Like this post"]', count: 0
      assert_select 'input[value="Unlike this post"]', count: 0

      assert_select ".comments", count: 1
      assert_select ".comment", count: 1
      assert_select ".comment-info", count: 1
      assert_select "a", text: "Delete comment", count: 0 # not author of comment
    end
  end

  def test_display_for_other_user
    my_sign_in @user
    get post_path(@post)
    assert_select ".post" do
      assert_select "a[href=?]", user_path(@author), count: 1
      assert_select ".post-title", text: @post.title, count: 1
      assert_select ".post-content", text: @post.content, count: 1
      assert_match @post.created_at.to_s, response.body
      assert_select ".like-count", text: '0 likes', count: 1

      assert_select "a[href=?]", edit_post_path(@post), count: 0
      assert_select "a", text: "Delete post", count: 0

      assert_select 'input[value="Like this post"]', count: 1
      assert_select 'input[value="Unlike this post"]', count: 0
    end

    Liking.create(post: @post, user: @user)
    get post_path(@post)
    assert_select ".post" do
      assert_select 'input[value="Like this post"]', count: 0
      assert_select 'input[value="Unlike this post"]', count: 1
      assert_select ".like-count", text: '1 like', count: 1

      assert_select ".comments", count: 1
      assert_select ".comment", count: 1
      assert_select ".comment-info", count: 1
      assert_select "a", text: "Delete comment", count: 1
    end
  end

end
