class Passenger < ActiveRecord::Base

  belongs_to :booking, inverse_of: :passengers

  validates :email, presence: true
  validates :name, presence: true
  validates :booking, presence: true

end
