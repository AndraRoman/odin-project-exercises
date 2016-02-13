require 'test_helper'

class BookingsControllerTest < ActionController::TestCase
  
  def test_get_new
    get 'new', flight_id: flights(:north).id, passenger_count: 2
    assert_response :success
    assert_template 'new'
    assert flash.empty?
  end

  def test_redirect_if_no_flight_in_request
    get 'new'
    assert_redirected_to root_path
    refute flash.empty?
  end

end
