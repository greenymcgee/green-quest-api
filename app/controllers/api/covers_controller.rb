class Api::CoversController < ApplicationController
  before_action :set_cover, only: %i[show destroy]

  # 200
  def index
    @covers = Cover.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @cover
    @cover.destroy!
  end

  private

  def set_cover
    @cover = Cover.find(params[:id])
  end
end
