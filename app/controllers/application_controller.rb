class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_game, :current_game?, :set_current_game=

  private

  def current_game
    @current_game
  end

  alias_method :current_game?, :current_game

  def set_current_game=(game)
    @current_game = game
  end
end
