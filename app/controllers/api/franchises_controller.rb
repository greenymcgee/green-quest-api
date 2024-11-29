class Api::FranchisesController < ApplicationController
  before_action :set_franchise, only: %i[show destroy]

  # 200
  def index
    @franchises = Franchise.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @franchise
    @franchise.destroy!
  end

  private

  def set_franchise
    @franchise = Franchise.find(params[:id])
  end
end
