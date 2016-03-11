class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :registerable, :validatable, :omniauthable, :omniauth_providers => [:facebook] # using validatable instead of rolling own password/email presence requirements. when I did the latter, edit page required password field to be filled as well as current_password in order to make any update - virtual attribute conflict

  # not sure I'll actually be using these associations
  has_many :active_friendships, class_name: "Friendship", inverse_of: :initiator, foreign_key: "initiator_id"
  has_many :passive_friendships, class_name: "Friendship", inverse_of: :recipient, foreign_key: "recipient_id"

  # badly named since not actually a friend unless confirmed
  has_many :active_friends, class_name: "User", through: :active_friendships, source: :recipient, inverse_of: :passive_friends # friends where self initiated friendship
  has_many :passive_friends, class_name: "User", through: :passive_friendships, source: :initiator, inverse_of: :active_friends # friends where friend initiated friendship

  has_many :posts, inverse_of: :user
  has_many :likings, inverse_of: :user
  has_many :comments, inverse_of: :user

  # paperclip
  has_attached_file :profile_pic, styles: { medium: "300x300", thumb: "100x100" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :profile_pic, content_type: ["image/jpeg", "image/gif", "image/png"]

  # copied straight from https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  # copied straight from https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  # copies data from session when user is initialized before signing up
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

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
