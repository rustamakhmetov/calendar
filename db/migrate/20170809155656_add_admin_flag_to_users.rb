class AddAdminFlagToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean
    add_index :users, :admin
  end
end
