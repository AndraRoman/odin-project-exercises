class Post < ActiveRecord::Base
  belongs_to :user, inverse_of: :posts
  has_many :comments, inverse_of: :post, dependent: :restrict_with_error

  validates :url, presence: true, length: {maximum: 255}
  validates :user, presence: true
end
