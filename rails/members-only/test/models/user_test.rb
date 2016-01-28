require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name:  "M. plicatulus",
                     email: "User@example.com",
                     password: "password",
                     password_confirmation: "password")
  end

  def test_create_valid_user
    assert(@user.valid?)
    @user.save
    remember_token = @user.remember_token
    assert(remember_token)
    assert_equal("user@example.com", @user.email)
    assert_equal(@user.remember_digest, User.digest(remember_token))
  end

  def test_email_presence_and_length_validations
    @user.email = nil
    refute(@user.valid?)
    @user.email = "a" * 256
    refute(@user.valid?)
  end

  def test_name_presence_and_length_validations
    @user.name = nil
    refute(@user.valid?)
    @user.name = "a" * 256
    refute(@user.valid?)
  end

  def test_name_uniqueness_validation
    @user.save
    other_user = User.new(name: "M. plicatulus", email: "test@example.com",
                          password: "password", password_confirmation: "password")
    refute(other_user.valid?)
  end

  def test_password_presence_and_length_validations
    @user.password = "bees"
    @user.password_confirmation = "bees"
    refute(@user.valid?)
    @user.password = nil
    @user.password_confirmation = nil
    refute (@user.valid?)
    @user.password = " " * 10
    @user.password_confirmation = " " * 10
    refute (@user.valid?)
  end

  def test_password_confirmation_validation
    @user.password_confirmation = "passworD"
    refute(@user.valid?)
  end

  def test_authenticate_user
    assert_equal(@user, @user.authenticate("password"))
    refute(@user.authenticate("password1"))
  end

end
