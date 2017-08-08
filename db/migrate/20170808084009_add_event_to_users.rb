class AddEventToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :event, foreign_key: true
  end
end
