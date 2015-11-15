class Board < ActiveRecord::Base
  # game reference
  belongs_to :game
  has_many :moves

  attr_reader :row, :column, :icon
  attr_reader :winner

  # To reset all cells of the board
  #
  # @return [Boolean] true/false
  def reset_board!
    return true if empty_board?

    reset_board
    save!
  end

  # To check if the board is empty
  #
  # @return [Boolean] true/false based
  #   on board condition
  def empty_board?
    cell_rows.flatten.uniq.size == 1 && cell_rows.flatten.uniq.first == nil
  end

  # To collect value for diagonals positions
  #
  # @return [Array] array of both diagonal array
  def diagonals
    [
        [self.r1_c1, self.r2_c2, self.r3_c3],
        [self.r1_c3, self.r2_c2, self.r3_c1]
    ]
  end

  # To get all row wise the grid values
  #
  # @return [Array] values from all grid positions
  def cell_rows
    cells = []

    # for each row
    1.upto(3).each do |row|
      rows = []
      # for each column
      1.upto(3).each do |column|
        rows << get_cell_value(row, column)
      end

      cells << rows
    end

    cells
  end

  # To get all column wise the grid values
  #
  # @return [Array] values from all grid positions
  def cell_columns
    cells = []
    # for each column
    1.upto(3).each do |column|
      grid = []

      # for each row
      1.upto(3).each do |row|
        grid << get_cell_value(row, column)
      end

      cells << grid
    end

    cells
  end

  # To collect a cell value
  #
  # @param [Integer] row takes value from 1 to 3, default: 1
  # @param [Integer] column takes value from 1 to 3, default: 1
  # @return [String] value- could be x, o or nil
  def get_cell_value(row = 1, column = 1)
    unless row.is_a?(Integer) && column.is_a?(Integer)
      raise IncorrectCellPosition, 'Incorrect cell position'.freeze
    end

    if row > 3 || column > 3
      raise OutOfCellError, 'No cell available in this zone'.freeze
    end

    self.send cell_column(row, column)
  end


  # For testing purposes
  #
  # @return [String] Cell wise views of the board
  def cell_view
    puts '---------------'
    puts "|  #{get_cell_value(3, 1) || ' '} | #{get_cell_value(3, 2) || ' '} | #{get_cell_value(3, 3) || ' '}  |"
    puts "|  #{get_cell_value(2, 1) || ' '} | #{get_cell_value(2, 2) || ' '} | #{get_cell_value(2, 3) || ' '}  |"
    puts "|  #{get_cell_value(1, 1) || ' '} | #{get_cell_value(1, 2) || ' '} | #{get_cell_value(1, 3) || ' '}  |"
    puts '---------------'
  end


  # Finding winner
  #
  # @return [Boolean] if this game is win mode
  def win?
    draw(diagonals) || draw(cell_columns) || draw(cell_rows)
  end

  # Finding game result
  #
  # @return [Boolean] if anyone wins or loose
  def draw(positions)
    positions.each do |diagonal|
      # make sure win
      if diagonal.uniq.count == 1 && !diagonal.uniq.first.nil?
        @winner = diagonal.uniq.first
        mark_win!

        return true
      end
    end

    false
  end

  # Finding if any move available
  #
  # @return [Boolean] true/false based on if move available
  def move_available?
    total_available_moves > 0
  end

  # Collecting empty cells
  #
  # @return [Integer] number of available moves
  def total_available_moves
    cell_rows.flatten.select { |cell| cell.nil? }.size
  end

  # To find if a match is drawn
  #
  # @return [Boolean] true/false if a match is drawn
  def drawn?
    # Conditions:
    # 1. No move available
    # 2. And no one wins
    if !move_available? && !win?
      mark_drawn!

      return true
    end

    false
  end

  # formatting json date for board
  def as_json
    {
        win:             self.win?,
        drawn:           self.drawn?,
        r1_c1:           self.r1_c1,
        r1_c2:           self.r1_c2,
        r1_c3:           self.r1_c3,
        r2_c1:           self.r2_c1,
        r2_c2:           self.r2_c2,
        r2_c3:           self.r2_c3,
        r3_c1:           self.r3_c1,
        r3_c2:           self.r3_c2,
        r3_c3:           self.r3_c3,
        moves:           self.moves,
        row_grid:        self.cell_rows,
        column_grid:     self.cell_columns,
        move_available:  self.move_available?,
        moves_available: self.total_available_moves
    }
  end

  # To perform a move on the board!
  #
  # @return [Boolean] true/false indicates if move
  #   is successful or not
  def move!(row, column, icon)
    @row, @column, @icon = row, column, icon

    make_move!
  end

  private
  # Its needed to find the column name for the right position
  #
  # @param [Integer] row it should be in between 1 & 3
  # @param [Integer] column it should be in between 1 & 3
  # @param [Boolean] reader default is true, a false
  #   value send the writer attributes
  #   for the desire cell.
  # @return [String] reader or writer accessor
  def cell_column(row, column, reader = true)
    return "r#{row}_c#{column}" if reader

    "r#{row}_c#{column}="
  end

  # Performing the move on the board
  #
  # @see #move!
  # @param [Integer] row represents y_axis value
  # @param [Integer] column represents x_axis value
  # @param [Integer] icon is the player icon
  def make_move!
    return false if get_cell_value(row, column).present?

    self.send cell_column(row, column, false), icon

    self.save
  end

  # When a winner wins a board
  #
  def mark_win!
    game.update_status(Game::WIN)
  end

  # When the match is drawn
  #
  def mark_drawn!
    game.update_status(Game::DRAWN)
  end

  # To set all cells to default value
  #
  def reset_board
    # append nil to all cells to reset
    self.r1_c1 = nil
    self.r1_c2 = nil
    self.r1_c3 = nil
    self.r2_c1 = nil
    self.r2_c2 = nil
    self.r2_c3 = nil
    self.r3_c1 = nil
    self.r3_c2 = nil
    self.r3_c3 = nil
  end
end