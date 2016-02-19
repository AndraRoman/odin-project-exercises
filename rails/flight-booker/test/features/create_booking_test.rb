require "test_helper"

class CreateBookingTest < Capybara::Rails::TestCase
  test "happy path to create booking" do

    flight_id = flights(:north).id

    visit root_path
    assert_selector 'form', count: 1 # have to use capybara method, not minitest equivalent, in feature tests
    select('LAX', from: 'origin_id')
    select('SFO', from: 'destination_id')
    select('3', from: 'passenger_count')
    click_button('Find flights!')
    assert_selector '.flight', count: 2
    
    # select tomorrow's flight
    choose("flight_id_#{flight_id}")
    click_button("Book flight!")

    assert_match('bookings/new', current_path) # capybara lacks assert_redirected_to
    assert_selector "#flight-#{flight_id}"

    # submit without valid passenger info
    click_button('Finalize booking!')
    assert_match('bookings/new', current_path)
    refute_text('SUCCESS')
    assert_text('missing')

    passengers = [{name: 'Alice', email: 'alice@example.com'}, {name: 'Bob', email: 'bob@example.com'}, {name: 'Eve', email: 'eve@example.com'}]

    passengers.each_with_index do |passenger, index|
      fill_in("booking_passenger_#{index}_name", with: passenger[:name])
      fill_in("booking_passenger_#{index}_email", with: passenger[:email])
    end

    # submit with valid passenger info
    click_button('Finalize booking!')
    assert_text('SUCCESS')
    assert_match(/bookings\/\d+/, current_path)
    assert_selector "#flight-#{flight_id}"
    assert_selector ".passenger", count: 3

  end

end
