class CreateUsersAndEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true
    end
  end
end
