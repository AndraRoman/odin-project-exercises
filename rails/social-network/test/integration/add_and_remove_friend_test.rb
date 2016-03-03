require 'test_helper'

class AddAndRemoveFriendTest < ActionDispatch::IntegrationTest

  def test_remove_active_friendship
    @user = users(:mixed)
    my_sign_in @user

    friend = friendships(:mixed_passive).recipient
    get user_path friend
    assert_difference '@user.friends.count', -1 do
      delete friendship_path(friend)
    end
    assert_match "removed", flash[:success]
  end

  def test_remove_active_friend
    @user = users(:mixed)
    my_sign_in @user

    friend = friendships(:active_mixed).initiator
    get user_path friend
    assert_difference '@user.friends.count', -1 do
      delete friendship_path(friend)
    end
    assert_match "removed", flash[:success]
  end

  def test_reject_request
    @user = users(:passive)
    my_sign_in @user

    requestor = friendships(:unconfirmed).initiator
    refute @user.stranger?(requestor)
    get user_path requestor
    assert_no_difference '@user.friends.count' do
      assert_difference '@user.passive_friendships.count', -1 do
        delete friendship_path(requestor)
      end
    end
    assert_match "removed", flash[:success]
  end

  def test_confirm_request
    @user = users(:passive)
    my_sign_in @user

    requestor = friendships(:unconfirmed).initiator
    refute @user.stranger?(requestor)
    get user_path requestor
    assert_difference '@user.friends.count', 1 do
      assert_no_difference '@user.passive_friendships.count' do
        patch friendship_path(requestor)
      end
    end
    assert_match "Accepted", flash[:success]
  end

end
