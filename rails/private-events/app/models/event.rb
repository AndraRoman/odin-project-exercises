class Event < ActiveRecord::Base

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :creator, presence: true # does not validate creator is valid fk

  belongs_to :creator, class_name: "User", inverse_of: :events

end
