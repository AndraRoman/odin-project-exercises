class Flight < ActiveRecord::Base

  include FlightsHelper

  belongs_to :origin, class_name: "Airport", inverse_of: :departing_flights
  belongs_to :destination, class_name: "Airport", inverse_of: :arriving_flights

  validates :origin, presence: true
  validates :destination, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :departure_time, presence: true

  validate :destination_is_not_origin

  def Flight.all_dates
    Flight.all.map { |f| f.departure_time.to_date }.uniq.sort
  end

  # not tested
  def display_duration
    time = Time.at(self.duration).utc
    time.strftime("%I:%M")
  end

  private

  def destination_is_not_origin
    if origin == destination
      errors.add(:destination, "Destination must be different from origin.")
    end
  end

  # any arg may be nil
  # int, int, str -> [Flight]
  def Flight.filter_by_search_params(origin_id, destination_id, date_str)
    destination_id = nil if destination_id.blank?
    date = date_str.in_time_zone('Pacific Time (US & Canada)') unless date_str.blank? # being lazy here
    end_of_date = date.end_of_day if date
    Flight.where("origin_id = ? AND (? IS NULL OR destination_id = ?) AND (? IS NULL OR departure_time BETWEEN ? AND ?)", origin_id, destination_id, destination_id, date, date, end_of_date)
  end

end
