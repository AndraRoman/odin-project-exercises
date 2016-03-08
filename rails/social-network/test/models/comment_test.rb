require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @comment = Comment.new(post: posts(:first), user: users(:active), content: "Great post!")
  end

  def test_accepts_valid_comment
    assert @comment.valid?
  end

  def test_comment_must_have_content
    @comment.content = ""
    refute @comment.valid?
  end

  def test_db_constraint_content_must_not_be_nil
    @comment.save
    assert_raise ActiveRecord::StatementInvalid do
      @comment.update_attribute(:content, nil)
    end
  end

  def test_comment_must_have_author
    @comment.user_id = 0
    refute @comment.valid?
  end

  def test_db_constraint_author_id_must_be_valid_user_id
    @comment.save
    assert_raise ActiveRecord::StatementInvalid do
      @comment.update_attribute(:user_id, 0)
    end
  end

  def test_comment_must_have_post
    @comment.post_id = 0
    refute @comment.valid?
  end

  def test_db_constraint_post_id_must_be_valid_post_id
    @comment.save
    assert_raise ActiveRecord::StatementInvalid do
      @comment.update_attribute(:post_id, 0)
    end
  end

end
