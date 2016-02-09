class EventsController < ApplicationController

  before_action :logged_in_user, only: :create

  def new
    @event = Event.new
  end

  # has to be @event, not just event, so else case has an @event object to pass to form
  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      flash[:success] = "Event created!"
      redirect_to @event
    else
      flash.now[:danger] = "We couldn't create that event. Try again and make sure all fields are filled."
      render 'new'
    end
  end

  def show
    @event = Event.find_by_id(params[:id])
    if @event
      @invitees = @event.invitees
    else
      render text: "404 ERROR: Could not find event with ID #{params[:id]}.", status: 404
    end
  end

  def index
    @events = Event.all
  end

  private

  def event_params
    params.require(:event).permit(:name, :location, :start_time, :description) # creator not passed as param
  end

end
