class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.references :player, index: true
      t.integer :x_axis
      t.integer :y_axis

      t.timestamps null: false
    end
  end
end
