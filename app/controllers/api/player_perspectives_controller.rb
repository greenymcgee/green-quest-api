class Api::PlayerPerspectivesController < ApplicationController
  before_action :set_player_perspective, only: %i[show destroy]

  # 200
  def index
    @player_perspectives = PlayerPerspective.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @player_perspective
    @player_perspective.destroy!
  end

  private

  def set_player_perspective
    @player_perspective = PlayerPerspective.find(params[:id])
  end
end
