class Api::CurrentUsersController < ApplicationController
  # 200, 401
  def show
    authenticate_user!
    @user = current_user
    render "api/users/show", status: :ok
  end
end
