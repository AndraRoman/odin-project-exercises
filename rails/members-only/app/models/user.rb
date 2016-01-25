class User < ActiveRecord::Base

  # inverse_of keeps different in-memory representations of data for a user in sync (load only one copy of the user object)
  # depenent: if you try to destroy a user who has any posts associated, the operation will fail and an error will be added to the user. this error will only be accessible from within the destroy method in the controller.
  # the double colons here are necessary
  has_many :posts, inverse_of: :user, dependent: :restrict_with_error
  before_save { self.email = email.downcase }

  # not validating format for now
  validates :email, presence: true, length: { maximum: 255 }
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: true
  # allow_nil lets user update their other attributes without submitting a password in the same form
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, allow_nil: true

  # adds methods to set and authenticate against a bcrypt password
  has_secure_password

end
