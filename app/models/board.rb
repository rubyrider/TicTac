class Board < ActiveRecord::Base

  # game reference
  belongs_to :game

  attr_accessor :winner

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


  def cell_view
    puts '---------------'
    puts "|  #{get_cell_value(3,1) || ' '} | #{get_cell_value(3,2) || ' '} | #{get_cell_value(3,3) || ' '}  |"
    puts "|  #{get_cell_value(2,1) || ' '} | #{get_cell_value(2,2) || ' '} | #{get_cell_value(2,3) || ' '}  |"
    puts "|  #{get_cell_value(1,1) || ' '} | #{get_cell_value(1,2) || ' '} | #{get_cell_value(1,3) || ' '}  |"
    puts '---------------'
  end


  def win?
    draw(diagonals) || draw(cell_columns) || draw(cell_rows)
  end

  def draw(positions)
    positions.each do |diagonal|
      if diagonal.uniq.count == 1
        @winner = diagonal.uniq.first

        return true
      end
    end

    return false
  end

end

class IncorrectCellPosition < StandardError
end

class OutOfCellError < StandardError
end