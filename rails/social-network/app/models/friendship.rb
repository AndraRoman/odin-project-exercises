class Friendship < ActiveRecord::Base

  belongs_to :initiator, class_name: "User", inverse_of: :initiated_friendships
  belongs_to :recipient, class_name: "User", inverse_of: :received_friendships

  validates :initiator, presence: true
  validates :recipient, presence: true

  validate :cannot_friend_self, :must_be_unique

  private

    def cannot_friend_self
      if initiator_id == recipient_id
        errors.add(:recipient, "can't be same as initiator")
      end
    end

    # TODO this reproduces some logic that will go in user #friend? method - too closely coupled, should pull out somewhere
    # named placeholders
    def must_be_unique
      unless Friendship.where("(initiator_id = :initiator_id AND recipient_id = :recipient_id) OR (initiator_id = :recipient_id AND recipient_id = :initiator_id)", initiator_id: initiator_id, recipient_id: recipient_id).empty?
        errors.add(:recipient, "friendship already exists")
      end
    end

end
