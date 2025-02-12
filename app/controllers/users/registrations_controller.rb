# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix

  respond_to :json

  private

  # 400, 422, 200
  def respond_with(user, _opts = {})
    require_password_confirmation
    return render_invalid_user_response(user) unless resource.persisted?

    render_valid_user_response(user)
  end

  def render_invalid_user_response(user)
    render(
      json: {
        status: "422",
        message:
          "User couldn't be created successfully. #{user.errors.full_messages.to_sentence}",
      },
      status: :unprocessable_entity,
    )
  end

  def render_valid_user_response(user)
    render "api/users/show", status: :ok
  end

  def require_password_confirmation
    params.require(:user).require(:password_confirmation)
  end

  # ##
  # Devise made these comments, and they may come in handy someday.
  # ##

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
