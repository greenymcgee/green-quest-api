class Api::ReleaseDatesController < ApplicationController
  before_action :set_release_date, only: %i[show destroy]

  # 200
  def index
    @release_dates = ReleaseDate.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @release_date
    @release_date.destroy!
  end

  private

  def set_release_date
    @release_date = ReleaseDate.find(params[:id])
  end
end
