class Api::ScreenshotsController < ApplicationController
  before_action :set_screenshot, only: %i[show destroy]

  # 200
  def index
    @screenshots = Screenshot.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @screenshot
    @screenshot.destroy!
  end

  private

  def set_screenshot
    @screenshot = Screenshot.find(params[:id])
  end
end
