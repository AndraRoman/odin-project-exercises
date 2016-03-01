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
    # TODO
  end

  # p for predicate since can't have '?' in middle of method name
  def test_friendp_returns_true_if_users_are_friends
    # TODO (both directions)
  end

  def test_friendp_returns_false_if_users_are_strangers
    # TODO
  end

  def test_friendp_returns_false_if_friendship_unconfirmed
    # TODO (both directions)
  end

  def test_received_friend_requests_returns_unconfirmed_received_requests
    # TODO (check directionality correct)
  end

  def test_strangerp_returns_true_if_users_are_strangers
    # TODO
  end

  def test_strangerp_returns_false_if_users_are_friends
    # TODO (both directions)
  end

  def test_strangerp_returns_false_if_friendship_unconfirmed
    # TODO (both directions)
  end


end
