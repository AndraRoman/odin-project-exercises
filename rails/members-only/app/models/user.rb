class User < ActiveRecord::Base

  attr_accessor :remember_token

  # inverse_of keeps different in-memory representations of data for a user in sync (load only one copy of the user object)
  # depenent: if you try to destroy a user who has any posts associated, the operation will fail and an error will be added to the user. this error will only be accessible from within the destroy method in the controller.
  # the double colons here are necessary

  has_many :posts, inverse_of: :user, dependent: :restrict_with_error

  # wait this makes NO SENSE
  before_create { self.memorize }
  before_save { self.email = email.downcase }

  # not validating format for now
  validates :email, presence: true, length: { maximum: 255 }
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: true
  # allow_nil lets user update their other attributes without submitting a password in the same form
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, allow_nil: true

  # adds methods to set and authenticate against a bcrypt password
  has_secure_password

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    Digest::SHA1.hexdigest(string)
  end

  # used in before_create callback for user, so can't save to db
  def memorize
    self.remember_token = User.new_token
    self.remember_digest = User.digest(remember_token.to_s)
  end

  # for known user but new session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token.to_s))
  end

end
