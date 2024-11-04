# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix

  respond_to :json

  private

  def respond_with(user, _opts = {})
    return render_invalid_user_response(user) unless resource.persisted?

    render_valid_user_response(user)
  end

  def render_invalid_user_response(user)
    render(
      json: {
        message:
          "User couldn't be created successfully. #{user.errors.full_messages.to_sentence}",
      },
      status: :unprocessable_entity,
    )
  end

  def render_valid_user_response(user)
    render(json: { user: get_user_attributes(user) }, status: :ok)
  end

  def get_user_attributes(user)
    user_serializer = UserSerializer.new(user)
    user_serializer.serializable_hash[:data][:attributes]
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
