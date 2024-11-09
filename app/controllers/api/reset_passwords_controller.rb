class Api::ResetPasswordsController < Devise::PasswordsController
  # 204, 422
  def create
    send_reset_password_instructions
    return head :created if successfully_sent?(resource)

    render_create_errors
  end

  # 204, 422
  def update
    perform_password_reset
    return handle_update_success if resource.errors.empty?

    render_update_errors
  end

  private

  def handle_update_success
    resource.unlock_access! if unlockable?(resource)
    resource.after_database_authentication
    resource
  end

  def render_create_errors
    render(
      json: {
        message: resource.errors.full_messages.join(","),
      },
      status: :unprocessable_entity,
    )
  end

  def send_reset_password_instructions
    self.resource =
      User.send_reset_password_instructions(
        email: create_reset_password_params[:email],
      )
  end

  def perform_password_reset
    self.resource =
      User.reset_password_by_token(
        reset_password_token: update_reset_password_params[:token],
        password: update_reset_password_params[:password],
        password_confirmation:
          update_reset_password_params[:password_confirmation],
      )
  end

  def render_update_errors
    render(
      json: {
        error: resource.errors.full_messages.join(","),
      },
      status: :unprocessable_entity,
    )
  end

  def create_reset_password_params
    params.permit(:email)
  end

  def update_reset_password_params
    params.permit(:password, :password_confirmation, :token)
  end
end
