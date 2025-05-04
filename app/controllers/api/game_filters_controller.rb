class Api::GameFiltersController < ApplicationController
  def index
    @companies = Company.with_games.order(:name)
    @genres = Genre.with_games.includes(:games).order(:name)
    @platforms = Platform.with_games.includes(:games).order(:name)
  rescue => error
    Rails.logger.error("GameFilters index error: #{error.message}")
    @companies = []
    @genres = []
    @platforms = []
    render :index, status: :internal_server_error
  end
end
