require 'rails_helper'

describe Game, type: :model do
  let!(:game) { create(:game) }
  let(:player) { game.player }
  let(:opponent) { game.opponent }


  describe '#start!' do
    let(:move) { attributes_for :move, player: player }

    context 'has player and opponent present' do
      it 'has a player' do
        expect(game.player).to be_present
      end

      it 'has a opponent present' do
        expect(game.opponent).to be_present
      end
    end

    context 'before started' do
      it 'can\'t move' do
        expect(game.can_move?).to be_falsey
      end

      it 'raise error on move' do
        expect { game.move!(move) }.to raise_error GameNotStarted
      end
    end

    context 'when started' do
      before { game.start! }

      it 'has started time' do
        expect(game.started_at).to be_present
      end

      it 'can make a move' do
        expect(game.can_move?).to be_truthy
      end
    end
  end

end
