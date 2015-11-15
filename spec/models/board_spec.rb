require 'rails_helper'

RSpec.describe Board, type: :model do
  let!(:board) { create(:board) }

  describe '#diagonals' do
    it 'should return a diagonals' do
      expect(board.diagonals).to be == [[1, 1, nil], [1, 1, 0]]
    end
  end

  describe '#get_cell_value' do
    it 'should have row wise 3 gird' do
      expect(board.get_cell_value(1, 1)).to be == 1
    end

    it 'should raise error if invalid row and column provided' do
      expect { board.get_cell_value('1', 'as') }.to raise_error IncorrectCellPosition
    end

    it 'should raise error if no cell position found' do
      expect { board.get_cell_value(5, 6) }.to raise_error OutOfCellError
    end
  end

  describe '#rows' do
    it 'should have rows' do
      expect(board.cell_rows).to be == [[1, 0, 1], [nil, 1, 0], [0, 0, nil]]
    end
  end

  describe '#columns' do
    it 'should have columns' do
      expect(board.cell_columns).to be == [[1, nil, 0], [0, 1, 0], [1, 0, nil]]
    end
  end

  describe '#win?' do
    context 'no one wins' do
      it 'gives correct result' do
        board.cell_view
        expect(board.win?).to be == false
      end
    end

    context 'when a player wins diagonally' do
      let!(:board) { create(:board, :winning_combination_by_diagonals) }

      it 'gives correct result' do
        board.reload.cell_view
        expect(board.win?).to be == true
      end
    end

    context 'when a player wins vertically' do
      let!(:board) { create :board, :winning_combination_by_rows }

      it 'gives correct result' do
        board.reload.cell_view
        expect(board.win?).to be == true
      end
    end

    context 'when a player wins horizontally' do
      let!(:board) { create :board, :winning_combination_by_columns }

      it 'gives correct result' do
        board.reload.cell_view
        expect(board.win?).to be == true
      end
    end
  end

  describe '#move_available?' do
    context 'when move available' do
      subject { board.reload.move_available? }

      it { is_expected.to be_truthy }
    end

    context 'when no move available' do
      let!(:board_with_no_move) { create :board, :no_move_available }

      it 'should return false' do
        board_with_no_move.cell_view

        expect(board_with_no_move.move_available?).to be_falsey
      end
    end
  end

  describe '#drawn?' do
    context 'when moves available' do
      it 'should return false' do
        expect(board.drawn?).to be_falsey
      end
    end

    context 'when no move available' do
      let!(:board_with_no_move) { create :board, :no_win_and_no_move }
      it 'should return true' do
        board_with_no_move.cell_view

        expect(board_with_no_move.drawn?).to be_truthy
      end
    end
  end
end
