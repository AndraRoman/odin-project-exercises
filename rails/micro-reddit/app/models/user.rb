class User < ActiveRecord::Base
  has_many :posts, inverse_of: :user, dependent: :restrict_with_error
  has_many :comments, inverse_of: :user, dependent: :restrict_with_error

  validates :username, presence: true, length: {maximum: 255}, uniqueness: true

  before_save {email.downcase!}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  INVALID_EMAIL_REGEX = /@.*\.\./
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}
  validates :email, format: {without: INVALID_EMAIL_REGEX}
end

