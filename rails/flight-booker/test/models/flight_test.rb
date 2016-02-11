require 'test_helper'

class FlightTest < ActiveSupport::TestCase

  def setup
    origin = airports(:lax)
    destination = airports(:sfo)
    duration = 300
    departure_time = DateTime.now + 2.days
    @flight = Flight.new(origin_id: origin.id, destination_id: destination.id, duration: duration, departure_time: departure_time)
  end

  def test_create_valid_flight
    assert @flight.valid?
  end

  def test_origin_is_required
    @flight.origin = nil
    refute @flight.valid?
  end

  def test_destination_is_required
    @flight.destination = nil
    refute @flight.valid?
  end

  def test_departure_time_is_required
    @flight.departure_time = nil
    refute @flight.valid?
  end

  def test_duration_validations
    @flight.duration = nil
    refute @flight.valid?
    @flight.duration = 0
    refute @flight.valid?
    @flight.duration = -100
    refute @flight.valid?
  end

  def test_destination_cannot_be_same_as_origin
    @flight.destination_id = @flight.origin_id
    refute @flight.valid?
  end

  def test_all_dates
    dates = Flight.all_dates
    assert_equal(2, dates.length)
    assert dates.include?(Date.tomorrow)
    assert dates.include?(Date.yesterday)
  end

end
