require 'test_helper'

class AirportTest < ActiveSupport::TestCase

  def setup
    @lax = airports(:lax)
    @sfo = airports(:sfo)
  end

  def test_create_valid_airport
    airport = Airport.new(code: 'YYY')
    assert airport.valid?
  end

  def test_code_uniqueness_validation
    assert Airport.first.code # so below tests right thing
    airport = Airport.new(code: Airport.first.code)
    refute airport.valid?
  end

  def test_code_presence_validation
    airport = Airport.new(code: " ")
    refute airport.valid?
  end

  def test_departing_flights
    assert @sfo.departing_flights.include?(flights(:south))
    refute @sfo.departing_flights.include?(flights(:north))
    refute @lax.departing_flights.include?(flights(:south))
    assert @lax.departing_flights.include?(flights(:north))
  end

  def test_arriving_flights
    assert @lax.arriving_flights.include?(flights(:south))
    refute @lax.arriving_flights.include?(flights(:north))
    refute @sfo.arriving_flights.include?(flights(:south))
    assert @sfo.arriving_flights.include?(flights(:north))
  end

end
