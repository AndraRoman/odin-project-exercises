class BookingsController < ApplicationController

  def new
    flight_id = booking_new_params[:flight_id]
    passenger_count = booking_new_params[:passenger_count]
    passenger_count = passenger_count.nil? || passenger_count.empty? ? 1 : passenger_count.to_i # ugh
    if flight_id
      @booking = Booking.new
      @flight = Flight.find_by(id: flight_id)
      @passengers = Array.new(passenger_count) { Passenger.new }
    else
      flash[:danger] = "You must select a flight before creating a booking."
      redirect_to root_path # this loses users's search, oh well
    end
  end

  def create
    @booking = Booking.new(booking_create_params)
    if @booking.save
      @passengers = passenger_create_params[:passenger].map { |passenger_params| @booking.passengers.build(passenger_params)  }
      @passengers.each { |p| p.save }
      redirect_to @booking
    else
      flash[:danger] = "Something went wrong in saving your booking. Maybe the flight has been canceled? Try again from the top."
      redirect_to root_path and return # TODO why is the 'and return' needed when the redirect is already the last action on this branch? also not giving redirect response code in tests, but does render correct thing so going to ignore it for now
    end
  end

  def show
    @booking = Booking.find_by(id: params[:id])
  end

  private

  def booking_new_params
    params.permit(:passenger_count, :flight_id)
  end

  def booking_create_params
    params.require(:booking).permit(:flight_id, :passenger_count)
  end

  def passenger_create_params
    params.require(:booking).permit(passenger: [:name, :email])
  end

end
