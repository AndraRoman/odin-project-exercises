require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def test_get_new
    get :sign_up
    assert_response :success
  end

end
