require 'test_helper'

class FlightIndexTest < ActionDispatch::IntegrationTest

  def setup
    @today = Date.current.to_s
    @tomorrow = Date.tomorrow.to_s
    @next_week = 7.days.from_now.to_date
    get root_path
  end

  def test_correct_options_are_shown
    assert_template 'flights/index'
    ['#origin_id', '#destination_id'].each_with_index do |selector, index|
      assert_select selector, count: 1 do
        assert_select 'option', text: 'LAX', count: 1
        assert_select 'option', text: 'SFO', count: 1
      end
    end
    assert_select 'option', text: @tomorrow, count: 1
    assert_select 'option', text: @next_week, count: 0
  end

  def test_no_flights_shown_without_origin_selected
    assert_select '.flight', count: 0
  end

  def test_dropdowns_retain_selected_items
    get root_path, origin_id: airports(:lax).id, destination_id: airports(:sfo).id, passenger_count: 3, date: @tomorrow
    assert_select 'option[selected]', text: @tomorrow, count: 1
    assert_select 'option[selected]', text: @today, count: 0
    assert_select 'option[selected]', text: "LAX", count: 1
    assert_select 'option[selected]', text: "SFO", count: 1
    assert_select 'option[selected]', text: "3", count: 1
    assert_select 'option[selected]', text: "2", count: 0
  end

  def test_partial_searches_show_filtered_results
    # origin only
    get root_path, origin_id: airports(:lax).id
    assert_select '.flight', count: 2
    # origin and destination
    get root_path, origin_id: airports(:lax).id, destination_id: airports(:sfo).id
    assert_select '.flight', count: 2
    # origin and date
    get root_path, origin_id: airports(:lax).id, date: @tomorrow
    assert_select '.flight', count: 1
  end

  def test_fully_specified_search
    get root_path, origin_id: airports(:lax).id, destination_id: airports(:sfo).id, passenger_count: 3, date: @tomorrow
    assert_select '.flight', count: 1
  end

  def test_select_flight
    # TODO (incl confirm is radio button so mutually exclusive)
  end

  def test_cannot_submit_flight_selection_without_any_flight_options
    # TODO
  end

end
