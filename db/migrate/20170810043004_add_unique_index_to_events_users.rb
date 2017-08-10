class AddUniqueIndexToEventsUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :events_users, [:user_id, :event_id], unique: true
  end
end
