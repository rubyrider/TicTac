class AddStatusToGame < ActiveRecord::Migration
  def change
    add_column :games, :status, :integer, default: 1
  end
end
