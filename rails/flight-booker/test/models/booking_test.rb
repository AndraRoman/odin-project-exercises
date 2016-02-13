require 'test_helper'

class BookingTest < ActiveSupport::TestCase

  def setup
    @booking = Booking.new(flight: flights(:north), passenger_count: 3)
  end

  def test_accepts_valid_booking
    assert @booking.valid?
  end

  def test_requires_passenger_count
    @booking.passenger_count = nil
    refute @booking.valid?
  end

  def test_passenger_count_must_be_in_range
    @booking.passenger_count = -1
    refute @booking.valid?
    @booking.passenger_count = 5
    refute @booking.valid?
  end

  def test_requires_flight_id
    @booking.flight_id = nil
    refute @booking.valid?
  end

end
