class Friendship < ActiveRecord::Base

  belongs_to :initiator, class_name: "User", inverse_of: :active_friendships
  belongs_to :recipient, class_name: "User", inverse_of: :passive_friendships

  validates :initiator, presence: true
  validates :recipient, presence: true

  validate :cannot_friend_self, :must_be_unique

  def confirm
    update_attributes(confirmed: true)
  end

  private

    def cannot_friend_self
      if initiator_id == recipient_id
        errors.add(:recipient, "can't be same as initiator")
      end
    end

    # TODO too closely coupled to user model
    def must_be_unique
      relationship = (recipient && initiator) ? recipient.relationship(initiator) : nil
      if relationship.instance_of?(Friendship) && relationship.id != id
        errors.add(:recipient, "friendship already exists")
      end
    end

end
