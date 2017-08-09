class Event < ApplicationRecord
  has_one :owner, class_name: "User"
  has_and_belongs_to_many :users

  alias_attribute :date, :created_at

  validates :body, presence: true
end
