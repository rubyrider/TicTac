class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :move, :start]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = GamePresenter.new(@game)
  end

  # GET /games/new
  def new
    @game = Game.new
    @game.build_player
    @game.build_opponent
  end

  # GET /games/1/edit
  def edit
  end

  def start
    if @game.start
      redirect_to @game, notice: 'Game has started successfully!'
    else
      redirect_to @game, error: 'Failed to start this game!'
    end
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def move
    if @game.move(move_params)
      respond_to do |format|
        format.html { redirect_to game_path(@game), notice: 'Move was successfully' }
        format.json { render json: @game.to_json }
      end
    else
      respond_to do |format|
        format.html { redirect_to game_path(@game), error: 'Failed to perform move' }
        format.json { render json: @game.errors.to_json }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  def move_params
    params.require(:move).permit([:x_axis, :y_axis])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_params
    params.require(:game).permit(
        :status, :started_at, :abandoned_at,
        :player_attributes   => [:name, :icon],
        :opponent_attributes => [:name, :icon],
    )
  end
end
