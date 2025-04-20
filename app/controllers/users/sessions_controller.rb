# frozen_string_literal: true

DEVISE_JWT_SECRET_KEY = Rails.application.credentials.devise_jwt_secret_key!

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix

  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    render "api/users/show", status: :ok
  end

  def respond_to_on_destroy
    set_current_verdant_veil_user
    return render_active_user_response if @current_verdant_veil_user.present?

    render_inactive_user_response
  end

  def render_active_user_response
    render(json: { message: "Logged out successfully." }, status: :ok)
  end

  def render_inactive_user_response
    render(
      json: {
        message: "Couldn't find an active session.",
      },
      status: :unauthorized,
    )
  end

  def set_request_auth_header
    @request_auth_header = request.headers["Authorization"]
  end

  def set_bearer_token
    return unless @request_auth_header.present?

    _, bearer_token = @request_auth_header.split(" ")
    @bearer_token = bearer_token
  end

  def set_jwt_payload
    return unless @bearer_token.present?

    jwt_payload, = JWT.decode(@bearer_token, DEVISE_JWT_SECRET_KEY)
    @jwt_payload = jwt_payload
  end

  def set_current_verdant_veil_user
    set_request_auth_header
    set_bearer_token
    set_jwt_payload
    return unless @jwt_payload.present?

    @current_verdant_veil_user = User.find(@jwt_payload["sub"])
  end

  # ##
  # Devise made these comments, and they may come in handy someday.
  # ##

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
