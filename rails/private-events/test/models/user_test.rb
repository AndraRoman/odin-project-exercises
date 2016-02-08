require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "A User")
    @user.save
  end

  def test_create_valid_user_with_downcased_name
    user = User.new(name: "A New User")
    assert(user.save)
    assert_equal('a new user', user.name)
  end

  def test_presence_validation
    user = User.new(name: " ")
    refute(user.valid?)
  end

  def test_uniqueness_validation
    user_2 = User.new(name: "a uSeR")
    refute(user_2.valid?)
  end

  def test_error_on_deleting_user_with_events
    creator = users(:douglass)
    event = events(:breakfast)
    creator.destroy # should fail w/o exception
    refute creator.errors.empty?
    refute creator.destroyed?
    event.destroy
    creator.destroy # should be fine now that event has been destroyed (ok that it's still in memory, just not in db)
    assert creator.destroyed?
  end

end
