class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  validates :url, presence: true, length: {maximum: 255}
end
