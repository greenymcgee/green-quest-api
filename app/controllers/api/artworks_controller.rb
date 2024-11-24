class Api::ArtworksController < ApplicationController
  before_action :set_artwork, only: %i[show destroy]

  # 200
  def index
    @artworks = Artwork.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @artwork
    @artwork.destroy!
  end

  private

  def set_artwork
    @artwork = Artwork.find(params[:id])
  end
end
