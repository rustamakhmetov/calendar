class Event < ApplicationRecord
  has_one :owner, class_name: "User"
  has_many :shares
  has_many :users, through: :shares

  alias_attribute :date, :created_at
  attr_accessor :email

  validates :owner, :body, presence: true

  before_destroy :delete_parents

  def share(user)
    user.events << self unless user.events.exists?(self.id)
  end

  def share_by_email(email)
    user = User.find_by(email: email)
    if user
      self.share(user)
    else
      self.errors.add(:base, "User not exists")
    end
    self
  end

  def set_viewed(user, value)
    _share = event_share(user)
    _share.update_attributes(viewed: value) if _share
  end

  def viewed?(user)
    _share = event_share(user)
    _share ? _share.viewed : false
  end

  private

  def delete_parents
    self.owner.update_attributes!(event_id: nil)
  end

  def event_share(user)
    shares.where(event_id: self.id, user_id: user.id).first
  end
end
