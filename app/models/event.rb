class Event < ApplicationRecord
  has_one :owner, class_name: "User"
  has_and_belongs_to_many :users

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

  private

  def delete_parents
    self.owner.update_attributes!(event_id: nil)
  end
end
