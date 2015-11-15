class AddLooserIdToPointTable < ActiveRecord::Migration
  def change
    add_column :point_tables, :looser_id, :integer
    add_index :point_tables, :looser_id
    add_index :point_tables, :winner_id
  end
end
