class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :r1_c1
      t.integer :r1_c2
      t.integer :r1_c3
      t.integer :r2_c1
      t.integer :r2_c2
      t.integer :r2_c3
      t.integer :r3_c1
      t.integer :r3_c2
      t.integer :r3_c3
      t.references :game

      t.timestamps null: false
    end
  end
end
