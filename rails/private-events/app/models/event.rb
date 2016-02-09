class Event < ActiveRecord::Base

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :creator, presence: true # does not validate creator is valid fk

  belongs_to :creator, class_name: "User", inverse_of: :created_events
  has_many :invitations, inverse_of: :event, dependent: :destroy # singular as there's one event per invitation - is this right?
  has_many :invitees, through: :invitations, class_name: "User", inverse_of: :invited_events, source: :invitee

  def Event.past
    Event.where("start_time < ?", DateTime.now)
  end

  def Event.upcoming
    Event.where("start_time > ?", DateTime.now)
  end

end
