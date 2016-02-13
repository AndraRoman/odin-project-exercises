require 'test_helper'

class BookingCreationTest < ActionDispatch::IntegrationTest

  def setup
    @flight = flights(:north)
  end

  def test_create_valid_booking
    get '/bookings/new', flight_id: flights(:north).id, passenger_count: 3
    assert_select 'input[type=text]', count: 6 # displays correct number of text fields
    assert_select '.flight', count: 1

    assert_difference 'Booking.count', 1 do
      assert_difference 'Passenger.count', 3 do
        post_via_redirect '/bookings', booking: {flight_id: flights(:north).id, passenger_count: 3, passenger: [{name: "A User", email: "a_user@example.com"}, {name: "C. Douglass", email: "cdouglass@example.com"}, {name: "John Smith", email: "jsmith@example.com"}]}
      end
    end

    assert_template 'bookings/show'
    assert_select '.passenger', count: 3
    assert_select '.flight', count: 1
  end

  def test_create_invalid_booking
    get root_path
    assert_no_difference 'Booking.count' do
      assert_no_difference 'Passenger.count' do
        post_via_redirect '/bookings', booking: {passenger_count: 3, passenger: [{name: "A User", email: "a_user@example.com"}, {name: "C. Douglass", email: "cdouglass@example.com"}, {name: "John Smith", email: "jsmith@example.com"}]}
      end
    end
    refute flash.empty?
    assert_template 'flights/index'
  end

end
