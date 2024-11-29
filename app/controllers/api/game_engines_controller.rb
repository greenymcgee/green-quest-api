class Api::GameEnginesController < ApplicationController
  before_action :set_game_engine, only: %i[show destroy]

  # 200
  def index
    @game_engines = GameEngine.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @game_engine
    @game_engine.destroy!
  end

  private

  def set_game_engine
    @game_engine = GameEngine.find(params[:id])
  end
end
