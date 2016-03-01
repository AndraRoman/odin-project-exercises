class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :registerable

  # not sure I'll actually be using these associations
  has_many :initiated_friendships, class_name: "Friendship", inverse_of: :initiator
  has_many :received_friendships, class_name: "Friendship", inverse_of: :recipient
  # skipping has_may friends through friendships

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
