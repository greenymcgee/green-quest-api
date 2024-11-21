class Api::InvolvedCompaniesController < ApplicationController
  before_action :set_involved_company, only: %i[show destroy]

  # 200
  def index
    @involved_companies = InvolvedCompany.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @involved_company
    @involved_company.destroy!
  end

  private

  def set_involved_company
    @involved_company = InvolvedCompany.find(params[:id])
  end
end
