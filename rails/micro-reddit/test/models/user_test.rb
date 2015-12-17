require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(username: "Fake_user", email: "test_user@example.com")
  end

  def test_user_is_valid
    assert @user.valid?
  end

  def test_valid_email_addresses_are_accepted
    valid_addresses = %w[user@example.com USER@goo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  def test_user_cannot_have_blank_or_empty_username
    @user.username = ""
    refute @user.valid?

    @user.username = nil
    refute @user.valid?
  end

  def test_username_must_be_unique
    duplicate_user = @user.dup
    @user.save
    refute duplicate_user.valid?
  end

  def test_db_enforces_username_uniqueness
    @user.save
    duplicate_user = User.create(email: "foo@example.com", username: "dup_user")
    assert_raise ActiveRecord::RecordNotUnique do
      begin
        duplicate_user.update_attribute(:username, @user.username)
      rescue Exception => e
        assert_match(/^PG::UniqueViolation: ERROR:  duplicate key value violates unique constraint/, e.message)
        raise e
      end
    end
  end

  def test_user_cannot_have_blank_or_empty_email
    @user.email = ""
    refute @user.valid?

    @user.email = nil
    refute @user.valid?
  end

  def test_user_email_must_have_valid_format
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com @example.com, foo@example..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      refute @user.valid?
    end
  end

  def test_email_cannot_be_too_long
    email = "a" * 244 + "@example.com"
    @user.email = email
    refute @user.valid?
  end

  def test_username_cannot_be_too_long
    username = "a" * 256
    @user.username = username
    refute @user.valid?
  end

  def test_email_downcased_before_save
    mixed_case_email = "Foo@ExAMPLe.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

end
