class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all
    authorize @users
    render "api/users/index"
  end

  def show
    authorize @user
    render "api/users/show"
  end

  def update
    authorize @user
    return render "api/users/show" if @user.update(user_params)

    render json: @user.errors, status: :unprocessable_entity
  end

  def destroy
    authorize @user
    @user.destroy!
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :username)
  end
end
