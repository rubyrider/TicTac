class Game < ActiveRecord::Base
  # Game Status:
  NOT_STARTED = 1
  RUNNING     = 2
  WIN         = 3
  DRAWN       = 4
  ABANDONED   = 5

  # player reference
  belongs_to :player
  # opponent reference
  belongs_to :opponent, class_name: 'Player', foreign_key: :opponent_id
  # board for a game
  has_one :board, dependent: :destroy
  # leaderboard
  has_many :point_tables, dependent: :destroy

  validates :player_id, :opponent_id, :presence => true, on: :update
  validates :status, presence: true, numericality: true

  after_create :setup_game_board

  accepts_nested_attributes_for :player
  accepts_nested_attributes_for :opponent

  # To perform the move on the board
  #
  # @return [Boolean] true/false, if move successful
  def move(move = {})
    begin
      move!(move)
    rescue => e
      errors.add :base, e.message
      return false
    end
  end


  # To perform the move on the board
  #
  # @return [Boolean] true/false, if move successful
  def move!(move = {})
    raise GameNotStarted, 'this game is not running' unless started?

    raise InvalidPlayerMove, 'this player is not authorized for this move' unless move_valid_for?(current_mover.id)

    if board.move!(move.fetch(:y_axis).to_i, move.fetch(:x_axis).to_i, current_mover.id)
      self.board.moves.create!(move)

      update_columns({last_player_id: current_mover.id})
    else
      return false
    end

    # checking out for possible result!
    game_over?

    true
  end

  # To response game data as json
  def as_json(options = nil)
    game_data
  end

  def game_data
    {
        id:            self.id,
        player:        self.player,
        opponent:      self.opponent,
        winner:        self.winner,
        game_over:     self.game_over?,
        last_moved_by: last_mover,
        next_move_id:  next_mover,
        status:        self.current_status,
        board:         self.board.as_json,
        started_at:    self.started_at,
        abandoned:     self.abandoned?,
        abandoned_at:  self.abandoned_at,
        created_at:    self.created_at
    }
  end

  # the last mover to valid whose move should be now!
  #
  # @return [Player]
  def last_mover
    Player.find(self.last_player_id) if last_player_id.present?
  end

  def winner
    Player.find(self.board.winner) if self.board.winner.present?
  end

  def game_over?
    win? || drawn?
  end

  # To find the the next mover, to select a mover
  #
  # @return [Player] player who can make the next move
  def next_mover
    # if no move has made yet!
    return player unless last_player_id.present?
    # if opponent was not the last mover
    return opponent if last_mover != opponent

    # if player wasn't the last mover
    player if last_mover != player
  end

  alias_method :current_mover, :next_mover
  # To get current game status
  #
  # @return [String] Statement of game's
  #   current status
  def current_status
    case status
      when NOT_STARTED
        return 'Game not started yet'.freeze
      when RUNNING
        return 'Game is running'.freeze
      when WIN
        return 'Game is won'.freeze
      when DRAWN
        return 'Game is drawn'.freeze
      when ABANDONED
        return 'Game is abandoned'.freeze
    end
  end

  def start
    begin
      start!
      board.reset_board!
      board.moves.delete_all
    rescue => e
      errors.add :base, e.message

      return false
    end
  end

  # To start the game
  #
  # @return [Boolean] true/false if game starting is done
  def start!
    return false if started?

    raise PlayerNotSelected, 'Both player and opponent is required' if player.nil? || opponent.nil?

    update_columns(
        {
            status:     Game::RUNNING,
            started_at: Time.zone.now
        }
    )

    true
  end

  # To abandon a game
  #
  # @return [Boolean] true when abandoning is done
  def abandoned!
    return true if abandoned?

    update_columns(
        {
            status:       Game::ABANDONED,
            abandoned_at: Time.zone.now
        }
    )

    true
  end

  # if the game has started already
  #
  # @return [Boolean] true if game started already
  #   unless false
  def started?
    !game_over? && status == Game::RUNNING && started_at.present?
  end
  
  alias_method :can_move?, :started?

  # if the game has left abandoned
  #
  # @return [Boolean] true if game started already
  #   unless false
  def abandoned?
    status == Game::ABANDONED && abandoned_at.present?
  end


  # update game status
  #
  def update_status(status_code)
    update_column :status, status_code.to_i
  end

  def win?
    status == Game::WIN
  end

  def drawn?
    status == Game::DRAWN
  end

  private

  def setup_game_board
    self.create_board
  end

  # Finding if the current move is valid for
  #   specific player
  #
  # @param [Integer] player_id is the id
  #    of the player to to be validated
  # @return [Boolean] true/false if the move is valid
  def move_valid_for?(player_id)
    return false if last_player_id == player_id

    true
  end
end
