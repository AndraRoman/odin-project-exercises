class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :registerable

  # not sure I'll actually be using these associations
  has_many :active_friendships, class_name: "Friendship", inverse_of: :initiator, foreign_key: "initiator_id"
  has_many :passive_friendships, class_name: "Friendship", inverse_of: :recipient, foreign_key: "recipient_id"

  # badly named since not actually a friend unless confirmed
  has_many :active_friends, class_name: "User", through: :active_friendships, source: :recipient # friends where self initiated friendship
  has_many :passive_friends, class_name: "User", through: :passive_friendships, source: :initiator # friends where friend initiated friendship

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  # TODO consolidate into single SQL query. This is awful.
  def friends
    friend_ids = active_friendships.where(confirmed: true).pluck(:recipient_id) + passive_friendships.where(confirmed: true).pluck(:initiator_id)
    User.where(id: friend_ids)
  end

  # TODO I don't like these either
  # named placeholders
  def relationship(user) # 
    return :self if user.id == id # TODO will I use this value?
    friendship_association = Friendship.where("(initiator_id = :own_id AND recipient_id = :other_id) OR (initiator_id = :other_id AND recipient_id = :own_id)", own_id: id, other_id: user.id)
    if friendship_association.empty?
      return nil
    else
      friendship_association.first
    end
  end

  def friend?(user)
    rel = relationship(user)
    rel.instance_of?(Friendship) && rel.confirmed
  end

  def stranger?(user)
    relationship(user).nil?
  end

  def waiting_friend_requests
    passive_friendships.where(confirmed: false)
  end

  def add_friend(user)
    active_friendships.create(recipient: user)
  end

  def confirm_friend(user)
    rel = relationship(user)
    rel.confirm if rel.instance_of?(Friendship) && rel.recipient_id == id
  end

  def remove_friend(user)
    rel = relationship(user)
    rel.destroy if rel
  end

end
