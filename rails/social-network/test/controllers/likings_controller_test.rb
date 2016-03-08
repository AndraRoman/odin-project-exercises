require 'test_helper'

class LikingsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @user = users(:stranger)
    @post = posts(:first)
    @liking = likings(:active_first)
  end

  def test_like_requires_logged_in_user
    assert_no_difference 'Liking.count', 1 do
      patch :create, post_id: @post.id
    end
    assert_redirected_to new_user_session_path
  end

  def test_like_when_logged_in
    sign_in @user
    assert_difference 'Liking.count', 1 do
      patch :create, post_id: @post.id
    end
  end

  def test_unlike_requires_logged_in_user
    assert_no_difference 'Liking.count' do
      delete :destroy, id: @liking.id
    end
    assert_redirected_to new_user_session_path
  end

  def test_unlike_when_logged_in
    sign_in @liking.user
    assert_difference 'Liking.count', -1 do
      delete :destroy, id: @liking.id
    end
  end

  def test_cannot_remove_another_users_like
    sign_in @user
    assert_no_difference 'Liking.count', 1 do
      delete :destroy, id: @liking.id
    end
  end

end
