class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :registerable

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
