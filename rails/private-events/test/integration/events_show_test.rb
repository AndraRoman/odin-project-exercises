require 'test_helper'

class EventsShowTest < ActionDispatch::IntegrationTest

  def setup
    @event = events(:dinner)
    @event_id = @event.id
  end

  def test_event_page_shows_invitees
    get "/events/#{@event_id}"
    assert_select 'li', text: "Who: #{@event.creator.name}", count: 1
    @event.invitees.each do |invitee|
      assert_select 'li', text: "#{invitee.name}", count: 1
    end
  end

  def test_404_if_event_not_found
    bad_event_id = 2412412
    refute Event.find_by(id: bad_event_id) # this is silly but do have to be sure the id isn't assigned
    get "/events/#{bad_event_id}"
    assert_match '404', response.body
    assert_response(:missing)
  end

  def test_event_page_shows_creator

  end

end
