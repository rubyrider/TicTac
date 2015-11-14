class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :player_id
      t.integer :opponent_id
      t.integer :result, default: 1
      t.datetime :abandoned_at
      t.datetime :started_at

      t.timestamps null: false
    end
    add_index :games, :opponent_id
  end
end
