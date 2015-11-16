class MovePresenter

  attr_reader :source
  attr_reader :player

  def initialize(source)
    @source = source
    @player = source.player
  end

  def player_name
    player.present? ? player.name : '-'
  end

  def moved_to
    "row #{source.y_axis} and column #{source.x_axis}"
  end
end