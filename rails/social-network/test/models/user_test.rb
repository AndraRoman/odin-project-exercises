require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "A User", email: "a_user@example.com")
  end

  def test_create_valid_user
    assert @user.valid?
  end

  def test_user_must_have_name
    @user.name = ""
    refute @user.valid?
    @user.name = nil
    refute @user.valid?
  end

  def test_user_must_have_email
    @user.email = ""
    refute @user.valid?
    @user.email = nil
    refute @user.valid?
  end

  def test_friends_returns_union_of_initiated_and_received_friends
    [users(:active), users(:mixed), users(:passive)].each do |user|
      assert_equal 2, user.friends.count
    end
  end

  # p for predicate since can't have '?' in middle of method name
  def test_friendp_returns_true_if_users_are_friends
    assert users(:active).friend?(users(:passive))
    assert users(:passive).friend?(users(:active))
  end

  def test_friendp_returns_false_if_users_are_strangers
    refute users(:active).friend?(users(:lonely))
  end

  def test_friendp_returns_false_if_friendship_unconfirmed
    refute users(:passive).friend?(users(:lonely))
    refute users(:lonely).friend?(users(:passive))
  end

  def test_waiting_friend_requests_returns_unconfirmed_received_requests
    assert friendships(:unconfirmed).initiator.waiting_friend_requests.empty?

    requests = friendships(:unconfirmed).recipient.waiting_friend_requests
    assert_equal 1, requests.size
    assert_equal friendships(:unconfirmed), requests.first
  end

  def test_strangerp_returns_true_if_users_are_strangers
    assert users(:active).stranger?(users(:lonely))
  end

  def test_strangerp_returns_false_if_users_are_friends
    refute users(:active).stranger?(users(:passive))
    refute users(:passive).stranger?(users(:active))
  end

  def test_strangerp_returns_false_if_friendship_unconfirmed
    refute users(:passive).stranger?(users(:lonely))
    refute users(:lonely).stranger?(users(:passive))
  end

  def test_strangerp_returns_false_if_users_are_same
    refute users(:passive).stranger?(users(:passive))
  end

  def test_add_friend_valid_case
    assert_difference 'Friendship.count', 1 do
      users(:lonely).add_friend(users(:active))
    end
  end

  def test_add_friend_when_friendship_already_confirmed
    assert_no_difference 'Friendship.count' do
      users(:active).add_friend(users(:passive))
      users(:passive).add_friend(users(:active))
    end
  end

  def test_add_friend_when_friendship_already_requested
    assert_no_difference 'Friendship.count' do
      users(:lonely).add_friend(users(:passive))
      users(:passive).add_friend(users(:lonely))
    end
  end

  def test_confirm_friend_valid_case
    friendship = friendships(:unconfirmed)
    initiator, recipient = [friendship.initiator, friendship.recipient]
    refute initiator.friend?(recipient)
    recipient.confirm_friend(initiator)
    assert initiator.friend?(recipient)
  end

  def test_initiator_cannot_confirm_friend
    friendship = friendships(:unconfirmed)
    initiator, recipient = [friendship.initiator, friendship.recipient]
    refute initiator.friend?(recipient)
    initiator.confirm_friend(recipient)
    refute initiator.friend?(recipient)
  end

  # just shouldn't raise any exceptions
  def test_confirm_friend_when_already_confirmed
    friendship = friendships(:active_passive)
    initiator, recipient = [friendship.initiator, friendship.recipient]
    recipient.confirm_friend(initiator)
    assert initiator.friend?(recipient)
  end

  def test_confirm_friend_when_no_request_exists
    initiator, recipient = [users(:lonely), users(:active)]
    refute initiator.friend?(recipient)
    initiator.confirm_friend(recipient)
    refute initiator.friend?(recipient)
  end

  def test_initiator_can_remove_friend_valid_case
    friendship = friendships(:active_passive)
    initiator, recipient = [friendship.initiator, friendship.recipient]
    assert initiator.friend?(recipient)
    assert_difference 'Friendship.count', -1 do
      initiator.remove_friend(recipient)
    end
  end

  def test_recipient_can_remove_friend_valid_case
    friendship = friendships(:active_passive)
    initiator, recipient = [friendship.initiator, friendship.recipient]
    assert initiator.friend?(recipient)
    assert_difference 'Friendship.count', -1 do
      recipient.remove_friend(initiator)
    end
  end

  def test_remove_friend_when_no_relationship_exists
    initiator, recipient = [users(:lonely), users(:active)]
    refute initiator.friend?(recipient)
    assert_no_difference 'Friendship.count' do
      recipient.remove_friend(initiator)
      initiator.remove_friend(recipient)
    end
  end

  def test_remove_friend_to_cancel_friend_request
    friendship = friendships(:unconfirmed)
    initiator, recipient = [friendship.initiator, friendship.recipient]
    refute initiator.friend?(recipient)
    assert_difference 'Friendship.count', -1 do
      initiator.remove_friend(recipient)
    end
  end

  def test_remove_friend_to_reject_friend_request
    friendship = friendships(:unconfirmed)
    initiator, recipient = [friendship.initiator, friendship.recipient]
    refute initiator.friend?(recipient)
    assert_difference 'Friendship.count', -1 do
      recipient.remove_friend(initiator)
    end
  end

end
