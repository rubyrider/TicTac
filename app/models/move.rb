class Move < ActiveRecord::Base
  belongs_to :player
  belongs_to :board

  def as_json
    {
        player: player.as_json,
        moved_on: self.created_at,
        moved_at: self.board.get_cell_value(y_axis, x_axis)
    }
  end
end
