require 'test_helper'

class LikingTest < ActiveSupport::TestCase

  def setup
    @liking = Liking.new(post: posts(:first), user: users(:active))
    @bad_user_id = 0
    @bad_post_id = 0
  end

  def test_accepts_valid_liking
    assert @liking.valid?
  end

  def test_cannot_like_own_post
    @liking.user = @liking.post.user
    refute @liking.valid?
  end

  def test_post_id_must_be_present
    @liking.post_id = nil
    refute @liking.valid?
  end

  def test_db_enforces_post_id_is_present
    @liking.save
    assert_raise ActiveRecord::StatementInvalid do
      @liking.update_attribute(:post_id, nil)
    end
  end

  def test_post_must_exist
    @liking.post_id = @bad_post_id
    refute @liking.valid?
  end

  def test_db_enforces_post_must_exist
    @liking.save
    assert_raise ActiveRecord::StatementInvalid do
      @liking.update_attribute(:post_id, @bad_post_id)
    end
  end

  def test_user_id_must_be_present
    @liking.user_id = nil
    refute @liking.valid?
  end

  def test_db_enforces_user_id_is_present
    @liking.save
    assert_raise ActiveRecord::StatementInvalid do
      @liking.update_attribute(:user_id, nil)
    end
  end

  def test_user_must_exist
    @liking.save
    assert_raise ActiveRecord::StatementInvalid do
      @liking.update_attribute(:user_id, @bad_user_id)
    end
  end

  def test_user_post_combination_must_be_unique
    new_liking = Liking.new(post: @liking.post, user: @liking.user)
    assert new_liking.valid?

    @liking.save
    refute new_liking.valid?
  end

  # TODO fails: looks like uniqueness constraint on multicolumn index is enforced in dev environment but not in test. Fix it!
  def test_db_enforces_user_post_combination_is_unique
    new_liking = Liking.new(post: @liking.post, user: users(:stranger))
    @liking.save
    assert new_liking.save
    
    assert_raise ActiveRecord::StatementInvalid do
      new_liking.update_attribute(:user_id, @liking.user_id)
    end
  end

end
