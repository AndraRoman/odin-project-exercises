require 'test_helper'

class FlightSelectionTest < ActionDispatch::IntegrationTest

  def setup
    @tomorrow = Date.tomorrow.to_s
  end

  def test_select_flight
    get root_path, origin_id: airports(:lax).id, destination_id: airports(:sfo).id, passenger_count: 3, date: @tomorrow
    assert_select 'input[type=radio]', count: 1
    assert_select '#result-count', text: '1', count: 1 # result count
    assert_select '#passenger-count', text: '3', count: 1 # passenger count
  end

  def test_cannot_submit_flight_selection_without_any_flight_options
    get root_path
    assert_select 'form', count: 1 # only 1 form since we haven't searched
    get root_path, origin_id: airports(:lax).id, destination_id: airports(:lax) # should have no results
    assert_select 'form', count: 2 # form present but no options
    assert_select 'input[type=radio]', count: 0 
    assert_select '#result-count', text: '0', count: 1 # result count
    assert_select '#passenger-count', text: '1', count: 1 # passenger count defaults to 1 when not submitted in form 1
  end



end
