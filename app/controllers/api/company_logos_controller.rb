class Api::CompanyLogosController < ApplicationController
  before_action :set_company_logo, only: %i[show destroy]

  # 200
  def index
    @company_logos = CompanyLogo.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @company_logo
    @company_logo.destroy!
  end

  private

  def set_company_logo
    @company_logo = CompanyLogo.find(params[:id])
  end
end
