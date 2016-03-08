class Post < ActiveRecord::Base

  belongs_to :user, inverse_of: :posts

  has_many :likings, inverse_of: :post, dependent: :destroy
  has_many :comments, inverse_of: :post, dependent: :destroy

  validates :title, presence: true, length: {maximum: 255}
  validates :content, presence: true
  validates :user, presence: true

end
