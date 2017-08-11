class AddViewedToShares < ActiveRecord::Migration[5.1]
  def change
    add_column :shares, :viewed, :boolean, default: false
    add_index :shares, :viewed
  end
end
