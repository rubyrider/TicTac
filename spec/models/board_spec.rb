require 'rails_helper'

RSpec.describe Board, type: :model do
  let!(:board) { create(:board) }

  describe "#diagonals" do
      it 'should return a diagonals' do
        expect(board.diagonals).to be == [[1, 1, 0], [1, 1, 0]]
      end
  end

  describe '#get_cell_value' do
    it 'should have row wise 3 gird' do
      expect(board.get_cell_value(1,1)).to be == 1
    end

    it 'should raise error if invalid row and column provided' do
      expect { board.get_cell_value('1', 'as')} .to raise_error IncorrectCellPosition
    end

    it 'should raise error if no cell position found' do
      expect { board.get_cell_value(5, 6) }.to raise_error OutOfCellError
    end
  end
end
