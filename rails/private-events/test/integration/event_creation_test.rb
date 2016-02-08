require 'test_helper'

class EventCreationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:douglass)
    log_in_as @user
  end

  def test_create_invalid_event
    get '/events/new'
    assert_no_difference 'Event.count' do
      #post_via_redirect events_path, event: { name: "my event", location: "", start_time: nil, description: ""}
      post_via_redirect events_path, event: { name: "my event", location: " ", start_time: DateTime.tomorrow, description: "fun!!!" }
    end
    assert_template 'new'
  end

  def test_create_valid_event
    get '/events/new'
    assert_difference 'Event.count', 1 do
      post_via_redirect events_path, event: { name: "my event", location: "here", start_time: DateTime.tomorrow, description: "fun!!!" }
    end
    assert_template 'show'

    event = Event.find_by(description: "fun!!!")
    assert_equal(@user, event.creator)
  end

end
