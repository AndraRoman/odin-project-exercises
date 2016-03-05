require 'test_helper'

class PostIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:passive)
    my_sign_in @user
  end

  def test_index_shows_correct_posts
    get posts_path
    assert_response :success
    assert_template 'posts/index'
    assert_select ".post", count: 3

    # own posts
    assert_match "Edit post", response.body, count: 1
    assert_match @user.email, response.body, count: 1

    # friends' posts
    assert_match users(:active).email, response.body, count: 2

    # no other posts
    refute_match posts(:stranger).user.email, response.body
  end

end
