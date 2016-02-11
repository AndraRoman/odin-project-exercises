class Flight < ActiveRecord::Base

  belongs_to :origin, class_name: "Airport", inverse_of: :departing_flights
  belongs_to :destination, class_name: "Airport", inverse_of: :arriving_flights

  validates :origin, presence: true
  validates :destination, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :departure_time, presence: true

  validate :destination_is_not_origin

  private

  def destination_is_not_origin
    if origin == destination
      errors.add(:destination, "Destination must be different from origin.")
    end
  end

end
