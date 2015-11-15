require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  let(:player) { create(:player) }
  let(:opponent) { create(:opponent) }

  # attributes
  let(:player_attributes) { attributes_for(:player) }
  let(:opponent_attributes) { attributes_for(:opponent) }
  let(:move) { attributes_for :move, player_id: player.id, x_axis: 2, y_axis: 3 }
  let(:opponent_move) { attributes_for :move, player_id: opponent.id, x_axis: 1, y_axis: 3 }

  let(:valid_attributes) {
    attributes_for(:game,
                   player_attributes:   player_attributes,
                   opponent_attributes: opponent_attributes
    )
  }

  let(:invalid_attributes) { { status: nil } }

  let!(:game) { create :game, valid_attributes }

  describe 'GET #show' do
    before { get :show, { :id => game.to_param } }

    it 'assigns the requested game as @game' do
      expect(assigns(:game)).to eq(game)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new game as @game' do
      expect(assigns(:game)).to be_a(Game)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do

      subject { post :create, { :game => valid_attributes } }

      it 'creates a new Game' do
        expect { subject }.to change(Game, :count).by(1)
      end

      it 'redirects to #show' do
        expect(subject).to redirect_to(game_path(assigns[:game].to_param))
      end
    end

    context 'with invalid params' do
      subject { post :create, { :game => invalid_attributes } }

      it 're-renders the new template' do
        expect(subject).to render_template('new')
      end
    end
  end

  describe '#move' do
    let!(:game) { create(:game, :running) }
    let(:player) { game.player }
    let(:opponent) { game.opponent }


    context 'with valid move' do
      context 'as a player' do
        subject { post :move, { move: move, id: game.to_param } }

        it 'should create a new move' do
          expect { subject }.to change(Move, :count).by(1)
        end

        it 'renders right message to the user' do
          subject
          expect(flash[:notice]).to be_present
        end
      end

      context 'as a json' do
        subject { post :move, { move: move, id: game.to_param, format: :json } }

        let(:json) { response.body }

        it 'should create a new move' do
          expect { subject }.to change(Move, :count).by(1)
        end

        it 'render game details' do
          subject
          expect(json).to be_present
        end
      end

      context 'as an opponent' do
        subject { post :move, { move: opponent_move, id: game.to_param } }

        it 'should create a new move' do
          expect { subject }.to change(Move, :count).by(1)
        end

        it 'renders right message to the user' do
          subject
          expect(flash[:notice]).to be_present
        end
      end
    end

    context 'with an invalid move' do
      subject { post :move, { move: opponent_move.merge!({x_axis: nil}), id: game.to_param } }

      it 'should create a new move' do
        expect { subject }.to change(Move, :count).by(0)
      end
    end
  end


  describe 'DELETE #destroy' do
    subject { delete :destroy, { :id => game.to_param } }

    it 'destroys the requested game' do
      expect { subject }.to change(Game, :count).by(-1)
    end

    it 'redirects to the games list' do
      expect(subject).to redirect_to(games_url)
    end
  end

end
