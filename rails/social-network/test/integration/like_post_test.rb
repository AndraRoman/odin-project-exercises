require 'test_helper'

class LikePostTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:active)
    @post = posts(:first)
    @liking = @user.likings.first
    my_sign_in @user
  end

  def test_like_post
    assert_difference 'Liking.count', 1 do
      post likings_path, post_id: @post.id
    end
  end

  def test_unlike_post
    assert_difference 'Liking.count', -1 do
      delete liking_path(id: @liking.id)
    end
  end

end
