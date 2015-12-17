require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @user = User.new(username: "Fake_user", email: "foo@example.com")
    @user.save
    @post = Post.new(url: "http://www.google.com", user_id: @user.id)
    @post.save
    @commenter = User.new(username: "Fake_commenter", email: "foo@example.com")
    @commenter.save
    @comment = Comment.new(body: "I liked that article!", user_id: @commenter.id, post_id: @post.id)
    @comment.save
  end

  def test_comment_is_valid
    assert @comment.valid?
  end

  def test_body_cannot_be_blank
    @comment.body = " 	"
    refute @comment.valid?

    @comment.body = nil
    refute @comment.valid?
  end

  def test_user_can_have_multiple_comments
    new_comment = @comment.dup
    new_comment.save
    assert_equal(2, @commenter.comments.length)
  end

  def test_post_can_have_multiple_comments
    new_comment = @comment.dup
    new_comment.save
    assert_equal(2, @post.comments.length)
  end

  def test_ar_enforces_user_existence
    @comment.user_id = 999
    refute @comment.valid?
  end

  def test_db_enforces_user_existence
    assert_raise_with_partial_message ActiveRecord::InvalidForeignKey,
      /^PG::ForeignKeyViolation.*insert or update on table "comments" violates foreign key constraint "user_id"/ do
     @comment.update_attribute(:user_id, 999)
   end
  end

  def test_ar_enforces_post_existence
    @comment.post_id = 999
    refute @comment.valid?
  end

  def test_db_enforces_post_id_constraint_on_save
    assert_raise_with_partial_message ActiveRecord::InvalidForeignKey,
      /^PG::ForeignKeyViolation.*insert or update on table "comments" violates foreign key constraint "post_id"/ do
     @comment.update_attribute(:post_id, 999)
   end
  end

  def test_ar_forbids_destroying_user_with_existing_comments
    assert_equal(false, @commenter.destroy)
  end

  def test_db_forbids_deleting_user_with_existing_comments
    assert_raise_with_partial_message ActiveRecord::InvalidForeignKey,
      /^PG::ForeignKeyViolation.*update or delete on table "users" violates foreign key constraint "user_id" on table "comments"/ do
     @commenter.delete
   end
  end

  def test_ar_forbids_destroying_post_with_existing_comments
    assert_equal(false, @post.destroy)
  end

  def test_db_forbids_deleting_post_with_existing_comments
    assert_raise_with_partial_message ActiveRecord::InvalidForeignKey,
      /^PG::ForeignKeyViolation.*update or delete on table "posts" violates foreign key constraint "post_id" on table "comments"/ do
     @post.delete
   end
  end

  def test_ar_forbids_null_user_id
    @comment.user_id = nil
    refute @comment.valid?
  end

  def test_db_forbids_null_user_id
    assert_raise_with_partial_message ActiveRecord::StatementInvalid,
      /^PG::NotNullViolation.*null value in column "user_id" violates not-null constraint/ do
     @comment.update_attribute(:user_id, nil)
   end
  end

  def test_ar_forbids_null_post_id
    @comment.post_id = nil
    refute @comment.valid?
  end

  def test_db_forbids_null_post_id
    assert_raise_with_partial_message ActiveRecord::StatementInvalid,
      /^PG::NotNullViolation.*null value in column "post_id" violates not-null constraint/ do
     @comment.update_attribute(:post_id, nil)
   end
  end
end

