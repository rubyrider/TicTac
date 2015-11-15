class AddRemainingMoveToPointTable < ActiveRecord::Migration
  def change
    add_column :point_tables, :remaining_moves, :integer, default: 0
  end
end
