class Liking < ActiveRecord::Base

  belongs_to :user, inverse_of: :likings
  belongs_to :post, inverse_of: :likings

  validates :user, presence: true
  validates :post, presence: true, :uniqueness => { :scope => :user_id }

  validate :cannot_like_own_post

  private

    def cannot_like_own_post
      return unless post && user && post.user # TODO this is repeating validations. Fix it.
      if user_id == post.user.id
        errors.add(:post, "author can't like their own post")
      end
    end

end
