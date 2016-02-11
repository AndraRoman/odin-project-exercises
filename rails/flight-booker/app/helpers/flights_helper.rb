module FlightsHelper

  def display_time(duration)
    time = Time.at(duration).utc
    time.strftime("%I:%M")
  end

end
