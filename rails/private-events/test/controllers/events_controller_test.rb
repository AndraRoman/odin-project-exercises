require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  def test_get_new
    get :new
    assert_response :success
  end

  def test_redirects_create_when_not_logged_in
    assert_no_difference 'Event.count' do
      post :create, event: { name: "my event", location: "here", start_time: DateTime.tomorrow, description: "fun!" }
    end
    assert_redirected_to login_url
  end

end
