require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def test_get_new
    get :new
    assert_response :success
  end

end
