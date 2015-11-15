class AddRefBoardToMove < ActiveRecord::Migration
  def change
    add_reference :moves, :board, index: true
    add_foreign_key :moves, :boards
  end
end
