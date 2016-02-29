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

end
