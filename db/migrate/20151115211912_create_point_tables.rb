class CreatePointTables < ActiveRecord::Migration
  def change
    create_table :point_tables do |t|
      t.references :game
      t.datetime :started_at
      t.integer :winner_id
      t.string :result
      t.datetime :ended_at

      t.timestamps null: false
    end
  end
end
