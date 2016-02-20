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
    @passengers = passenger_create_params[:passenger].map { |index, passenger_params| @booking.passengers.build(passenger_params) }
    if handle_transaction(@booking, @passengers)
      @passengers.each do |passenger|
        PassengerMailer.thank_you_email(passenger).deliver_later
      end
      redirect_to @booking
      flash[:now] = "SUCCESSFULLY SAVED BOOKING"
    elsif @passengers.any? { |p| p.invalid? }
      flash[:danger] = "Please re-enter passenger information. It looks like something was missing."
      redirect_to :back
    else
      flash[:danger] = "Something was wrong with your booking. You'll have to begin again from the start."
      redirect_to root_url
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

  # might belong in model instead? unsure
  def handle_transaction(booking, passengers)
    booking.transaction do
      begin
        booking.save
        passengers.each {|p| p.save}
      rescue ActiveRecord::StatementInvalid
        raise ActiveRecord::Rollback
      end
    end
    !booking.new_record?
  end

end
