class Api::GenresController < ApplicationController
  before_action :set_genre, only: %i[show destroy]

  # 200
  def index
    @genres = Genre.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @genre
    @genre.destroy!
  end

  private

  def set_genre
    @genre = Genre.find(params[:id])
  end
end
