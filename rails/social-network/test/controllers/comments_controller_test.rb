require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @old_comment = comments(:passive_comments_on_stranger_post)
    @user = @old_comment.user
    @post = @old_comment.post
  end

  def test_redirects_create_when_not_logged_in
    assert_no_difference 'Comment.count' do
      post :create, comment: { post_id: @post.id, content: "This is a test. This is a test of the outdoor warning system. This is only a test." }
    end
    assert_redirected_to new_user_session_path
  end

  def test_friendly_forward_after_successful_creation
    sign_in @user
    @request.env['HTTP_REFERER'] = root_path # workaround for controller tests: {HTTP_REFERER: path} as final parameter of post request only works in integration tests
    assert_difference 'Comment.count', 1 do
      post :create, comment: { post_id: @post.id, content: "This is a test. This is a test of the outdoor warning system. This is only a test." }
    end
    assert_redirected_to root_path
  end

  def test_redirect_to_post_after_successful_creation_without_referrer
    sign_in @user
    assert_difference 'Comment.count', 1 do
      post :create, comment: { post_id: @post.id, content: "This is a test. This is a test of the outdoor warning system. This is only a test." }
    end
    assert_redirected_to @post
  end

  def test_redirects_destroy_when_not_logged_in
    assert_no_difference 'Comment.count' do
      delete :destroy, id: @old_comment.id
    end
    assert_redirected_to new_user_session_path
  end

  def test_friendly_forward_for_destroy_when_logged_in_as_wrong_user
    sign_in users(:active)
    @request.env['HTTP_REFERER'] = root_path
    assert_difference 'Comment.count', 0 do
      delete :destroy, id: @old_comment.id
    end
    assert_redirected_to root_path
  end

  def test_redirects_destroy_when_logged_in_as_wrong_user_without_referrer
    sign_in users(:active)
    assert_difference 'Comment.count', 0 do
      delete :destroy, id: @old_comment.id
    end
    assert_redirected_to @post
  end

  def test_friendly_forward_after_successful_destruction
    sign_in @user
    @request.env['HTTP_REFERER'] = root_path
    assert_difference 'Comment.count', -1 do
      delete :destroy, id: @old_comment.id
    end
    assert_redirected_to root_path
  end

  def test_redirect_to_post_after_successful_destruction_without_referrer
    sign_in @user
    assert_difference 'Comment.count', -1 do
      delete :destroy, id: @old_comment.id
    end
    assert_redirected_to @post
  end

end
