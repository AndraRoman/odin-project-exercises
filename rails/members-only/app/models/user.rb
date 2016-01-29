class User < ActiveRecord::Base

  attr_accessor :remember_token # virtual attribute

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

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # This (rather than TOP's recommended SHA1) is necessary for authenticated? to work (at least in tests)
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # TOP wants this to be done in a before_create callback but I'd rather not
  def remember
    self.remember_token = User.new_token
    self.remember_digest = User.digest(self.remember_token)
    update_attribute(:remember_digest, self.remember_digest) #for new user, this creates record
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # taken from Hartl
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

end
