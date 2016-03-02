require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:passive)
    my_sign_in @user
  end

  def test_user_index_shows_all_users
    assert_template 'users/index'
    User.all.each do |user|
      assert_match user.email, response.body
    end
  end

  def test_user_index_shows_friend_buttons_for_strangers
    my_sign_out
    user = users(:lonely)
    my_sign_in user
    stranger_count = User.count - (user.active_friendships.count + user.passive_friendships.count + 1)
    assert_select 'input[value="Send friend request"]', count: stranger_count
  end

  def test_user_index_shows_unfriend_buttons_for_friends
    assert_select 'input[value=Unfriend]', count: @user.friends.count
  end

end
