class User < ActiveRecord::Base

  has_many :events, inverse_of: :creator, dependent: :restrict_with_error, foreign_key: "creator_id"

  before_save { self.name = name.downcase }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

end
