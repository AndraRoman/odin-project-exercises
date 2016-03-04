class Post < ActiveRecord::Base

  belongs_to :user, inverse_of: :posts

  validates :title, presence: true, length: {maximum: 255}
  validates :content, presence: true
  validates :user, presence: true

end
