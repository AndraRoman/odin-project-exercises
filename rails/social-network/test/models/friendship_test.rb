require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase

  def setup
    @friendship = Friendship.new(initiator: users(:active), recipient: users(:lonely))
    @bad_user_id = 0
    refute User.find_by(id: @bad_user_id) # not great - confusing if setup assertion fails
  end

  def test_accepts_valid_friendship
    assert @friendship.valid?
  end

  def test_confirmed_defaults_to_false
    assert_equal false, @friendship.confirmed
  end

  def test_confirmed_must_be_present
    @friendship.save
    assert_raise ActiveRecord::StatementInvalid do # PG::NotNullBiolation
      @friendship.update_attribute(:confirmed, nil)
    end
  end

  def test_initiator_must_be_valid_user
    @friendship.initiator_id = @bad_user_id
    refute @friendship.valid?
  end

  def test_fk_constraint_on_initiator
    @friendship.save
    assert_raise ActiveRecord::StatementInvalid do
      @friendship.update_attribute(:initiator_id, @bad_user_id)
    end
  end

  def test_recipient_must_be_valid_user
    @friendship.recipient_id = @bad_user_id
    refute @friendship.valid?
  end

  def test_fk_constraint_on_recipient
    @friendship.save
    assert_raise ActiveRecord::StatementInvalid do
      @friendship.update_attribute(:recipient_id, @bad_user_id)
    end
  end

  def test_cannot_friend_self
    @friendship.recipient = @friendship.initiator
    refute @friendship.valid?
    assert_match "can't be same as initiator", @friendship.errors.messages[:recipient][0]
  end

  def test_must_be_unique
    original = friendships(:active_passive)
    duplicate = Friendship.new(initiator: original.initiator, recipient: original.recipient)
    refute duplicate.valid?
    assert_match "friendship already exists", duplicate.errors.messages[:recipient][0]
  end

  def test_must_not_be_mirror_of_existing_friendship
    original = friendships(:active_passive)
    duplicate = Friendship.new(initiator: original.initiator, recipient: original.recipient)
    refute duplicate.valid?
    assert_match "friendship already exists", duplicate.errors.messages[:recipient][0]
  end

  def test_confirm_unconfirmed_friendship
    friendship = friendships(:unconfirmed)
    refute friendship.confirmed

    friendship.confirm
    assert friendship.confirmed
  end

end
