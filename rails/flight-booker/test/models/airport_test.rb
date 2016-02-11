require 'test_helper'

class AirportTest < ActiveSupport::TestCase

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

end
