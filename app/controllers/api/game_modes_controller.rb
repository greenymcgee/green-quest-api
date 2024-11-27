class Api::GameModesController < ApplicationController
  before_action :set_game_mode, only: %i[show destroy]

  # 200
  def index
    @game_modes = GameMode.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @game_mode
    @game_mode.destroy!
  end

  private

  def set_game_mode
    @game_mode = GameMode.find(params[:id])
  end
end
