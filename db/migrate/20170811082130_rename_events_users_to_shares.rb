class RenameEventsUsersToShares < ActiveRecord::Migration[5.1]
  def change
    rename_table :events_users, :shares
  end
end
