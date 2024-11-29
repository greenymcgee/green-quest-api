class Api::GameEngineLogosController < ApplicationController
  before_action :set_game_engine_logo, only: %i[show destroy]

  # 200
  def index
    @game_engine_logos = GameEngineLogo.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @game_engine_logo
    @game_engine_logo.destroy!
  end

  private

  def set_game_engine_logo
    @game_engine_logo = GameEngineLogo.find(params[:id])
  end
end
