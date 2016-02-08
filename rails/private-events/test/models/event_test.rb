require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def test_name_validation
    event = Event.new(name: " ", start_time: DateTime.now, location: "The world", creator: users(:douglass))
    refute event.valid?
  end

  def test_start_time_validation
    event = Event.new(name: "Hello, world!", start_time: nil, location: "The world", creator: users(:douglass))
    refute event.valid?
  end

  def test_location_validation
    event = Event.new(name: "Hello, world!", start_time: DateTime.now, location: " ", creator: users(:douglass))
    refute event.valid?
  end

  def test_creator_validation
    event = Event.new(name: "Hello, world!", start_time: DateTime.now, location: "The world")
    refute event.valid?
  end

  def test_create_valid_event
    event = Event.new(name: "Hello, world!", start_time: DateTime.now, location: "The world", creator: users(:douglass))
    assert event.save
  end

end
