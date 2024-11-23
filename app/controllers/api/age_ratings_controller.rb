class Api::AgeRatingsController < ApplicationController
  before_action :set_age_rating, only: %i[show destroy]

  # 200
  def index
    @age_ratings = AgeRating.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @age_rating
    @age_rating.destroy!
  end

  private

  def set_age_rating
    @age_rating = AgeRating.find(params[:id])
  end
end
