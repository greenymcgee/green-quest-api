class ApplicationController < ActionController::API
  include Pundit::Authorization

  respond_to :json

  before_action :configure_permitted_user_params, if: :devise_controller?

  protected

  def permit_user_params(user_params)
    user_params.permit(
      { roles: [] },
      :email,
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :username,
    )
  end

  def configure_permitted_user_params
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      permit_user_params(user_params)
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      permit_user_params(user_params)
    end
  end
end
