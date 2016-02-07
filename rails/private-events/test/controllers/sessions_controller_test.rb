require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def test_gets_new_session
    get :new
    assert_response(:success)
  end

end
