class Post < ActiveRecord::Base
  belongs_to :user

  validates :url, presence: true, length: {maximum: 255}
end
