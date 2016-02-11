class Airport < ActiveRecord::Base

  has_many :departing_flights, class_name: "Flight", inverse_of: :origin, foreign_key: "origin_id"
  has_many :arriving_flights, class_name: "Flight", inverse_of: :destination, foreign_key: "destination_id"

  validates :code, presence: true, uniqueness: true

end
