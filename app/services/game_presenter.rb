class GamePresenter

  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::AssetUrlHelper

  # reader for game properties
  attr_reader :source
  attr_reader :board
  attr_reader :player
  attr_reader :opponent
  attr_reader :point_table_list

  # constructor for the presenter
  def initialize(game)
    @source         = game
    @board        = source.board
    @player       = source.player
    @opponent     = source.opponent
    @point_table_list = source.point_tables
  end

  def moves
    board.moves.order('created_at DESC').collect { |mv| MovePresenter.new(mv) } if board.present?
  end

  def last_match_winner
    point_tables.first.winner.try(:name) if point_tables.size > 0
  end

  def current_turner
    source.current_mover.name if source.current_mover.present?
  end

  def player_name
    "#{player.name}" if player.present?
  end

  def opponent_name
    opponent.name if opponent.present?
  end

  def player_icon(row, col, height = 30, width = 30)
    get_player_icon(board.get_cell_value(row, col))
  end

  def get_player_icon(id, height = 30, width = 30)
    if player.id == id
      return image_tag asset_path('/assets/circle.jpg'.freeze), width: width, height: height
    end

    return image_tag asset_path('/assets/cross.jpg'.freeze), width: width, height: height
  end

  def available_moves
    board.present? ? board.total_available_moves : 0
  end

  def total_moves
    moves.present? ? moves.count : 0
  end

  def point_tables
    @pt = point_table_list.order(created_at: :desc).collect { |pt| PointTablePresenter.new(pt) }
  end
end