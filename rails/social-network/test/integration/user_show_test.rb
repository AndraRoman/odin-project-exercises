require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:active)
    my_sign_in @user
  end

  def test_404_if_user_not_found
    invalid_user_id = 0
    refute User.find_by(id: invalid_user_id)
    get "/users/#{invalid_user_id}"
    assert_response :missing
  end

  def test_gets_user_profile
    get user_path(@user)
    assert_response :success
  end

  def test_shows_friend_button_on_stranger
    get user_path(users(:lonely))
    assert_select 'input[value="Send friend request"]'
    assert_select '.btn', count: 1 # no other buttons
  end

  def test_shows_unfriend_button_on_friend
    get user_path(users(:passive))
    assert_select 'input[value="Unfriend"]'
    assert_select '.btn', count: 1
  end

  def test_shows_no_button_on_self
    get user_path(@user)
    assert_select '.btn', count: 0
  end

  def test_shows_no_button_on_recipient_of_pending_friendship
    friendship = friendships(:unconfirmed)
    my_sign_out
    my_sign_in friendship.initiator
    get user_path(friendship.recipient)
    assert_select '.btn', count: 0
  end

  def test_shows_no_button_on_initiator_of_pending_friendship
    friendship = friendships(:unconfirmed)
    my_sign_out
    my_sign_in friendship.recipient
    get user_path(friendship.initiator)
    assert_select '.user' do
      assert_select '.btn', count: 0
    end
  end

end
