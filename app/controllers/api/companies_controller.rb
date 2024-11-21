class Api::CompaniesController < ApplicationController
  before_action :set_company, only: %i[show destroy]

  # 200
  def index
    @companies = Company.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @company
    @company.destroy!
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end
end
