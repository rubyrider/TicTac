class AddLastPlayerIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :last_player_id, :integer
  end
end
