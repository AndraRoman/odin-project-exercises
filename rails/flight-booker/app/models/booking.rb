class Booking < ActiveRecord::Base

  belongs_to :flight, inverse_of: :bookings
  has_many :passengers, inverse_of: :booking
  # TODO accepts_nested_attributes_for :passengers

  validates :flight, presence: true
  validates :passenger_count, inclusion: { in: 1..4 } # not really necessary

end
