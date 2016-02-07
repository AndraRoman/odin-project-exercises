require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_create_valid_user_with_downcased_name
    user = User.new(name: "A User")
    assert(user.save)
    assert_equal('a user', user.name)
  end

  def test_presence_validation
    user = User.new(name: " ")
    refute(user.valid?)
  end

  def test_uniqueness_validation
    user_1 = User.new(name: "A User")
    user_1.save
    user_2 = User.new(name: "a uSeR")
    refute(user_2.valid?)
  end

end
