class Api::CurrentUsersController < ApplicationController
  # 200, 401
  def show
    authenticate_user!
    @user = current_user
    render :show, status: :ok
  end
end
