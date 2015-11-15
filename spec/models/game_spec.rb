require 'rails_helper'

describe Game, type: :model do
  let!(:game) { create(:game) }
  let(:player) { game.player }
  let(:opponent) { game.opponent }
  let(:move) { attributes_for :move, player_id: player.id, x_axis: 2, y_axis: 3 }
  let(:opponent_move) { attributes_for :move, player_id: opponent.id, x_axis: 3, y_axis: 3 }

  context 'has player and opponent present' do
    it 'has a player' do
      expect(game.player).to be_present
    end

    it 'has a opponent present' do
      expect(game.opponent).to be_present
    end
  end

  context 'when game is initialized' do
    it 'creates a board' do
      expect(game.board).to be_a Board
    end

    it 'board is persisted' do
      expect(game.board.persisted?).to be_truthy
    end
  end

  context 'when having a result' do
    let!(:game) { create(:game, winning_game: true) }

    before { game.board.win? }

    it 'gets a winner' do
      game.board.cell_view
      expect(game.point_tables.last.result).to be_present
    end

    it 'award a player as a winner' do
      expect(game.point_tables.last.winner).to be_a Player
    end

    it 'award to the right winner' do
      expect(game.point_tables.last.winner).to be == game.player
    end
  end

  describe '#start!' do
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

  describe '#move!' do
    before { game.start! }

    context 'when started successfully' do

      it 'player can make a move' do
        expect(game.can_move?).to be_truthy
      end

      context 'with a valid move request' do
        subject { game.move!(move) }

        it 'can make a move' do
          expect { subject }.to change(Move, :count).by(1)
        end

        context 'after a successful move' do

          before { game.move!(move) }

          it 'can add a cell on the game board' do
            expect(game.board.r3_c2).to be == player.id
          end

          it 'added a move successfully' do
            expect(game.board.moves.count).to be > 0
          end

          context 'once player move is done' do

            before { game.move!(move) }

            it 'can\'t allow the same player to make a move' do
              expect(game.move!(move)).to be_falsey
            end

            it 'can allow opponent to move' do
              expect { game.move!(opponent_move) }.to change(Move, :count).by(1)
            end

            context 'when opponent make a move' do
              before { game.move!(opponent_move) }

              it 'added another move on the board by opponent user' do
                expect(game.board.r3_c3).to be_present
              end

              it 'can\'t allow to make another move by same player' do
                expect(game.move!(opponent_move)).to be_falsey
              end

              describe '#as_json' do
                [
                    :id, :player, :opponent, :winner,
                    :game_over, :last_moved_by,
                    :next_move_id, :status, :board,
                    :started_at, :abandoned, :abandoned_at,
                    :created_at
                ].each do |key|
                  it "has a #{key} attribute" do
                    expect(game.as_json.keys.include?(key)).to be_truthy
                  end
                end
              end
            end
          end
        end
      end
    end
  end


end
