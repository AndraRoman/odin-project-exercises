class User < ActiveRecord::Base

  has_many :created_events, class_name: "Event", inverse_of: :creator, dependent: :restrict_with_error, foreign_key: "creator_id"
  has_many :invitations, inverse_of: :invitee, dependent: :destroy, foreign_key: "invitee_id" # invitee singular as there's one invitee per invitation. foreign key must be specified so that events can find invitees.
  has_many :invited_events, class_name: "Event", through: :invitations, inverse_of: :invitees, dependent: :destroy, source: :event # I have no idea what this source is doing

  before_save { self.name = name.downcase }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

end
