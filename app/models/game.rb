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
  has_one :board

  # To perform the move on the board
  #
  # @return [Boolean] true/false, if move successful
  def move!(move = {})
    raise GameNotStarted, 'This game is not running' unless started?

    raise InvalidPlayerMove, 'This player is not authorized for this move' unless
        move_valid_for?(move.require(:player_id))

    if  board.make_move!(move.require(:y_axis), move.require(:x_axis), move.require(:player_id))
      self.board.moves.create!(move)

      update_column(:last_player_id, move.require(:player_id))
    else

    end
  end

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


  # To start the game
  #
  # @return [Boolean] true/false if game starting is done
  def start!
    return false if started?

    update_columns(
        {
            status:     Board::RUNNING,
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

    {
        status:       Board::ABANDONED,
        abandoned_at: Time.zone.now
    }

    true
  end

  # if the game has started already
  #
  # @return [Boolean] true if game started already
  #   unless false
  def started?
    status == Board::RUNNING && started_at.present?
  end

  # if the game has left abandoned
  #
  # @return [Boolean] true if game started already
  #   unless false
  def abandoned?
    status == Board::ABANDONED && abandoned_at.present?
  end


  # update game status
  #
  def update_status(status_code)
    update_column :status, status_code.to_i
  end

  private

  # Finding if the current move is valid for
  #   specific player
  #
  # @param [Integer] player_id is the id
  #    of the player to to be validated
  # @return [Boolean] true/false if the move is valid
  def move_valid_for?(player_id)
    if last_player_id == player_id
      errors.add :base, 'not a valid move for current player'

      return false
    end

    true
  end
end
