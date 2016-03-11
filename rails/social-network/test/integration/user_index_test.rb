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
      assert_select 'h2', text: user.name, minimum: 1
      assert_select "a[href=?]", user_path(user), minimum: 1 # @user has pending friend request so that user will be linked twice
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
    assert_select '#user_index' do
      assert_select 'input[value=Unfriend]', count: @user.friends.count
    end
  end

  def test_user_index_shows_profile_pics_when_present
    assert_select 'img', count: 1
  end

end
