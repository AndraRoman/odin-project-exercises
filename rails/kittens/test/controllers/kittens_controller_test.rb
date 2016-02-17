require 'test_helper'

class KittensControllerTest < ActionController::TestCase

  def test_gets_new
    get :new
    assert_response :success
  end

end
