class Api::PlatformLogosController < ApplicationController
  before_action :set_platform_logo, only: %i[show destroy]

  # 200
  def index
    @platform_logos = PlatformLogo.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @platform_logo
    @platform_logo.destroy!
  end

  private

  def set_platform_logo
    @platform_logo = PlatformLogo.find(params[:id])
  end
end
