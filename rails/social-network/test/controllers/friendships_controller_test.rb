require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @user = users(:passive)
    @friendship = friendships(:unconfirmed)
    refute @friendship.confirmed
  end

  def test_create_requires_logged_in_user
    assert_no_difference 'Friendship.count' do 
      post :create, recipient_id: @user.id
    end
    assert_redirected_to new_user_session_path
  end

  def test_create_when_logged_in
    sign_in @user
    recipient = users(:stranger)
    assert_difference 'Friendship.count', 1 do 
      post :create, recipient_id: recipient.id
    end
    assert_redirected_to recipient
  end

  def test_update_requires_logged_in_user
    patch :update, id: @friendship.id
    refute @friendship.reload.confirmed
    assert_redirected_to new_user_session_path
  end

  def test_update_when_logged_in
    sign_in @user
    patch :update, id: @friendship.id
    assert @friendship.reload.confirmed
    assert_redirected_to @friendship.initiator
  end

  def test_destroy_requires_logged_in_user
    assert_no_difference 'Friendship.count' do 
      delete :destroy, id: @friendship.id
    end
    assert_redirected_to new_user_session_path
  end

  def test_destroy_when_logged_in
    sign_in @user
    assert_difference 'Friendship.count', -1 do 
      delete :destroy, id: @friendship.id
    end
    assert_redirected_to root_path
  end

end
