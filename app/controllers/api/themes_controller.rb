class Api::ThemesController < ApplicationController
  before_action :set_theme, only: %i[show destroy]

  # 200
  def index
    @themes = Theme.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @theme
    @theme.destroy!
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end
end
