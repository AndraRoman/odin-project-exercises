class Comment < ActiveRecord::Base
  belongs_to :post, inverse_of: :comments
  belongs_to :user, inverse_of: :comments

  validates :body, presence: true
  validates :user, presence: true
  validates :post, presence: true
end
