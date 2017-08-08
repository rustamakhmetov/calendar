class User < ApplicationRecord
  has_and_belongs_to_many :events

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def create_event(date, body)
    event = Event.new(owner: self, body: body, created_at: date)
    event.users << self
    event.save
    event
  end

  def events_by_date(date)
    self.events.where("DATE(created_at) = ?", date)
  end
end
