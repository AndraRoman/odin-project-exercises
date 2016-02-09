require 'test_helper'

class EventsIndexTest < ActionDispatch::IntegrationTest

  def test_event_index
    get events_path
    assert_template 'events/index'
    Event.all.each do |event|
      assert_select 'h3', text: event.name
    end
  end

end
