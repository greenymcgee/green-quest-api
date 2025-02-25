class Api::GameVideosController < ApplicationController
  before_action :set_game_video, only: %i[show destroy]

  # 200
  def index
    @game_videos = GameVideo.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @game_video
    @game_video.destroy!
  end

  private

  def set_game_video
    @game_video = GameVideo.find(params[:id])
  end
end
