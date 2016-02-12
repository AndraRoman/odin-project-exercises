class BookingsController < ApplicationController

  def new
    if booking_params[:flight_id]
      @booking = Booking.new
    else
      flash[:danger] = "You must select a flight before creating a booking."
      redirect_to root_path # this loses users's search, oh well
    end
  end

  def create
  end

  private

  def booking_params
    params.permit(:passenger_count, :flight_id)
  end

end
