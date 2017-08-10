class Event < ApplicationRecord
  has_one :owner, class_name: "User"
  has_and_belongs_to_many :users

  alias_attribute :date, :created_at

  validates :owner, :body, presence: true

  before_destroy :delete_parents

  def share(user)
    user.events << self unless user.events.exists?(self.id)
  end

  private

  def delete_parents
    self.owner.update_attributes!(event_id: nil)
  end
end
