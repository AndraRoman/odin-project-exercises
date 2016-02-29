require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:a_user)
  end

  def test_user_index_requires_login
    # TODO
  end

  def test_user_index_shows_all_users
    # TODO
  end

end
