class Event < ApplicationRecord
  has_one :owner, class_name: "User"
  has_and_belongs_to_many :users

  validates :body, presence: true
end
