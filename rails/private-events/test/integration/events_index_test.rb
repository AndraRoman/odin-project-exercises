require 'test_helper'

class EventsIndexTest < ActionDispatch::IntegrationTest

  def test_event_index_shows_all_events
    get events_path
    assert_template 'events/index'
    Event.all.each do |event|
      assert_select 'h3', text: event.name
    end
  end

  def test_event_index_separates_past_and_upcoming_events
    get events_path
    assert_select ".upcoming-events", count: 1 do
      assert_select 'h3', text: 'breakfast', count: 0
      assert_select 'h3', text: 'lunch', count: 0
      assert_select 'h3', text: 'dinner', count: 1
    end
    assert_select ".past-events", count: 1 do
      assert_select 'h3', text: 'breakfast', count: 1
      assert_select 'h3', text: 'lunch', count: 1
      assert_select 'h3', text: 'dinner', count: 0
    end
  end

end
