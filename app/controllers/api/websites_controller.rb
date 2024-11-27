class Api::WebsitesController < ApplicationController
  before_action :set_website, only: %i[show destroy]

  # 200
  def index
    @websites = Website.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @website
    @website.destroy!
  end

  private

  def set_website
    @website = Website.find(params[:id])
  end
end
