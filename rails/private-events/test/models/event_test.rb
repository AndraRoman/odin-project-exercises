require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @user = users(:douglass)
  end

  def test_name_validation
    event = Event.new(name: " ", start_time: DateTime.now, location: "The world", description: "party", creator: @user)
    refute event.valid?
  end

  def test_start_time_validation
    event = Event.new(name: "Hello, world!", start_time: nil, location: "The world", description: "party", creator: @user)
    refute event.valid?
  end

  def test_location_validation
    event = Event.new(name: "Hello, world!", start_time: DateTime.now, location: " ", description: "party", creator: @user)
    refute event.valid?
  end

  def test_description_validation
    event = Event.new(name: "Hello, world!", start_time: DateTime.now, location: "The world", creator: @user)
    refute event.valid?
  end

  def test_creator_validation
    event = Event.new(name: "Hello, world!", start_time: DateTime.now, location: "The world", description: "party")
    refute event.valid?
  end

  def test_create_valid_event
    event = Event.new(name: "Hello, world!", start_time: DateTime.now, location: "The world", description: "party", creator: @user)
    assert event.save # fail
  end

end
