require 'test_helper'

class BookingCreationTest < ActionDispatch::IntegrationTest

  def setup
    @flight = flights(:north)
  end

  def test_create_valid_booking
    get '/bookings/new', flight_id: @flight.id, passenger_count: 3
    assert_select 'input[type=text]', count: 6 # displays correct number of text fields
    assert_select '.flight', count: 1

    assert_difference 'Booking.count', 1 do
      assert_difference 'Passenger.count', 3 do
        post_via_redirect '/bookings', booking: {flight_id: @flight.id, passenger_count: 3, passenger: {0 => {name: "A User", email: "a_user@example.com"}, 1 => {name: "C. Douglass", email: "cdouglass@example.com"}, 2 => {name: "John Smith", email: "jsmith@example.com"}}} # index isn't used, just there to give fields unique ids
      end
    end

    assert_template 'bookings/show'
    assert_select '.passenger', count: 3
    assert_select '.flight', count: 1
  end

  def test_create_invalid_booking
    get root_path
    assert_no_difference 'Booking.count' do
      assert_no_difference 'Passenger.count' do # missing flight id
        post_via_redirect '/bookings', booking: {passenger_count: 3, passenger: {0 => {name: "A User", email: "a_user@example.com"}, 1 => {name: "C. Douglass", email: "cdouglass@example.com"}, 2 => {name: "John Smith", email: "jsmith@example.com"}}}
      end
    end
    refute flash.empty?
    assert_template 'flights/index'
  end

  def test_create_booking_with_invalid_passengers
    get root_path
    assert_no_difference 'Booking.count' do
      assert_no_difference 'Passenger.count' do
        post_via_redirect '/bookings', {booking: {flight_id: @flight.id, passenger_count: 3, passenger: {0 => {name: "", email: "a_user@example.com"}, 1 => {name: "C. Douglass", email: ""}, 2 => {name: "John Smith", email: "jsmith@example.com"}}}}, {'HTTP_REFERER' => "/bookings/new?passenger_count=1&flight_id=#{@flight.id}&commit=Book+flight!"}
      end
    end
    refute flash.empty?
    assert_template 'bookings/new'
  end

end
