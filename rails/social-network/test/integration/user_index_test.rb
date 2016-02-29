require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:a_user)
  end

  def test_user_index_shows_all_users
    my_sign_in users(:a_user)
    assert_template 'users/index'
    User.all.each do |user|
      assert_match user.email, response.body
    end
  end

end
