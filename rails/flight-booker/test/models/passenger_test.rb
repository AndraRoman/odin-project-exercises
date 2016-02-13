require 'test_helper'

class PassengerTest < ActiveSupport::TestCase

  def setup
    @passenger = Passenger.new(name: "J. Random Mole", email: "gdbg@example.com", booking: bookings(:first))
  end

  def test_accepts_valid_passenger
    assert @passenger.valid?
  end

  def test_requires_name
    @passenger.name = ' '
    refute @passenger.valid?
  end

  def test_requires_email
    @passenger.email = ' '
    refute @passenger.valid?
  end

  def test_requires_booking
    @passenger.booking_id = nil
    refute @passenger.valid?
  end

end
