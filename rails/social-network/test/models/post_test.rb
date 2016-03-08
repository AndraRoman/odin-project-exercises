require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @post = Post.new(user: User.first, title: "First post!", content: "Hello, world!")
  end

  def test_accepts_valid_post
    assert @post.valid?
  end

  def test_post_must_have_title
    @post.title = ""
    refute @post.valid?
  end

  def test_post_must_have_content
    @post.content = ""
    refute @post.valid?
  end

  def test_post_must_have_author
    @post.user = nil
    refute @post.valid?
  end

  def test_fk_constraint_that_author_must_be_valid_user
    @post.save
    bad_user_id = 0
    refute User.find_by(id: bad_user_id)
    assert_raise ActiveRecord::StatementInvalid do
      @post.update_attribute(:user_id, bad_user_id)
    end
  end

  def test_destroying_post_destroys_likes_and_comments
    delendus = posts(:stranger)
    assert_difference ['Liking.count', 'Post.count', 'Comment.count'], -1 do
      delendus.destroy
    end
  end

end
