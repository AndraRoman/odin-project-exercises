require 'test_helper'

class AddAndRemoveFriendTest < ActionDispatch::IntegrationTest

  def test_remove_passive_friend
    @user = users(:mixed)
    my_sign_in @user

    friendship = friendships(:mixed_passive)
    friend = friendship.recipient
    get user_path friend
    assert_difference '@user.friends.count', -1 do
      delete friendship_path(friendship), {}, {'HTTP_REFERER' => user_path(friend)}
    end
    assert_match "removed", flash[:success]
    assert_redirected_to friend
  end

  def test_remove_active_friend
    @user = users(:mixed)
    my_sign_in @user

    friendship = friendships(:active_mixed)
    friend = friendship.initiator
    get user_path friend
    assert_difference '@user.friends.count', -1 do
      delete friendship_path(friendship), {}, {'HTTP_REFERER' => user_path(friend)}
    end
    assert_match "removed", flash[:success]
    assert_redirected_to friend
  end

  def test_reject_request
    @user = users(:passive)
    my_sign_in @user

    friendship = friendships(:unconfirmed)
    requestor = friendship.initiator
    refute @user.stranger?(requestor)
    assert_select ".friend_request", count: 1

    get user_path requestor
    assert_no_difference '@user.friends.count' do
      assert_difference '@user.passive_friendships.count', -1 do
        delete friendship_path(friendship)
      end
    end
    assert_match "removed", flash[:success]
    assert_select ".friend_request", count: 0
  end

  def test_header_shows_notification_of_request
    @user = users(:passive)
    my_sign_in @user

    assert_select "#header" do
      assert_select "a[href=?]", user_path(users(:lonely)), count: 1
    end
  end

  def test_confirm_request
    @user = users(:passive)
    my_sign_in @user

    friendship = friendships(:unconfirmed)
    requestor = friendship.initiator
    refute @user.stranger?(requestor)
    assert_select ".friend_request", count: 1

    get user_path requestor
    assert_difference '@user.friends.count', 1 do
      assert_no_difference '@user.passive_friendships.count' do
        patch friendship_path(friendship)
      end
    end
    assert_match "Accepted", flash[:success]
    assert_select ".friend_request", count: 0
  end

  def test_cannot_destroy_another_users_friendship
    @user = users(:lonely)
    my_sign_in @user
    friendship = friendships(:active_passive)

    assert_no_difference 'Friendship.count' do
      delete friendship_path(friendship)
    end
  end

  def test_cannot_confirm_another_users_friendship
    @user = users(:active)
    my_sign_in @user

    friendship = friendships(:unconfirmed)
    patch friendship_path(friendship)

    refute friendship.confirmed
  end

  def test_request_friendship
    @user = users(:active)
    my_sign_in @user
    other_user = users(:stranger)

    get user_path(other_user)
    assert_difference 'Friendship.count', 1 do
      post friendships_path, recipient_id: other_user.id
    end
  end

end
