class FlightsController < ApplicationController

  def index
    @dates = Flight.all_dates
    @airport_options = Airport.airport_options
    @airport_options = Airport.airport_options
    if search_params[:origin_id] # no results shown without specifying origin - would be slow to load without any filtering
      @origin_id = search_params[:origin_id]
      @destination_id = search_params[:destination_id]
      @passenger_count = search_params[:passenger_count]
      @date = search_params[:date] 
      @flights = Flight.filter_by_search_params(@origin_id, @destination_id, @date)
    end
  end

  private

  def search_params
    params.permit(:date, :passenger_count, :destination_id, :origin_id)
  end

end
