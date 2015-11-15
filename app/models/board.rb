class Board < ActiveRecord::Base
  # game reference
  belongs_to :game

  # To reset all cells of the board
  #
  # @return [Boolean] true/false
  def reset_board!
    return true if empty_board?

    reset_board
    save!
  end

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

    self.send "r#{row}_c#{column}"
  end


  # For testing purposes
  #
  # @return [String] Cell wise views of the board
  def cell_view
    puts '---------------'
    puts "|  #{get_cell_value(3,1) || ' '} | #{get_cell_value(3,2) || ' '} | #{get_cell_value(3,3) || ' '}  |"
    puts "|  #{get_cell_value(2,1) || ' '} | #{get_cell_value(2,2) || ' '} | #{get_cell_value(2,3) || ' '}  |"
    puts "|  #{get_cell_value(1,1) || ' '} | #{get_cell_value(1,2) || ' '} | #{get_cell_value(1,3) || ' '}  |"
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

        return true
      end
    end

    false
  end

  # Finding if any move available
  #
  # @return [Boolean] true/false based on if move available
  def move_available?
    cell_rows.flatten.select {|cell| cell.nil?}.size > 0
  end

  # To find if a match is drawn
  #
  # @return [Boolean] true/false if a match is drawn
  def drawn?
    # Conditions:
    # 1. No move available
    # 2. And no one wins
    !move_available? && !win?
  end

  private

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

class IncorrectCellPosition < StandardError

end

class OutOfCellError < StandardError
end