class Api::PlatformsController < ApplicationController
  before_action :set_platform, only: %i[show destroy]

  # 200
  def index
    @platforms = Platform.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @platform
    @platform.destroy!
  end

  private

  def set_platform
    @platform = Platform.find(params[:id])
  end
end
