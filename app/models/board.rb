class Board < ActiveRecord::Base

  # game reference
  belongs_to :game

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
  def rows
    result = []
    1.upto(2) do |row|
      grid = []

      1.upto(2) do |column|
        grid << get_cell_value(row, column)
      end

      result << grid
    end
  end

  # To get all column wise the grid values
  #
  # @return [Array] values from all grid positions
  def columns
    result = []
    1.upto(2) do |column|
      grid = []

      1.upto(2) do |row|
        grid << get_cell_value(column, row)
      end

      result << grid
    end
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

end

class IncorrectCellPosition < StandardError
end

class OutOfCellError < StandardError
end