class Share < ApplicationRecord
  belongs_to :user #, class_name: 'RailwayStation', foreign_key: :railway_station_id
  belongs_to :event
end