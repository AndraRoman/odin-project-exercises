require 'test_helper'

class CommentOnPostTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:active)
    @post = posts(:first)
    @comment = comments(:active_comments_on_first_post)
    my_sign_in @user
  end

  def test_create_comment
    get post_path(@post)
    assert_select ".comment", count: 1
    assert_difference 'Comment.count', 1 do
      post comments_path, comment: {post_id: @post.id, content: "This is only a test"}
    end
    assert_redirected_to @post
    follow_redirect!
    assert_select ".comment", count: 2
  end

  def test_destroy_comment
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment)
    end
    assert_redirected_to @post
    follow_redirect!
    assert_select ".comment", count: 0
  end

end
