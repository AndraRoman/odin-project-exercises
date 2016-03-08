class Comment < ActiveRecord::Base

  belongs_to :post, inverse_of: :comments
  belongs_to :user, inverse_of: :comments

  validates :post, presence: true
  validates :user, presence: :true
  validates :content, presence: true

end
