class Api::GamesController < ApplicationController
  before_action :set_game, only: %i[show update destroy]

  # 200
  def index
    @games = Game.all
  end

  # 200, 404
  def show
  end

  # 200, 401, 403
  def create
    authenticate_user!
    @game = Game.new(game_params)
    authorize @game
    if @game.update(game_params)
      return render_successful_show_response(:created)
    end

    render json: @game.errors, status: :unprocessable_entity
  end

  # 200, 401, 403, 404
  def update
    authenticate_user!
    authorize @game
    return render_successful_show_response(:ok) if @game.update(game_params)

    render json: @game.errors, status: :unprocessable_entity
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @game
    @game.destroy!
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:igdb_id, :rating, :review)
  end

  def render_successful_show_response(status)
    render :show, status: status, location: api_game_url(@game)
  end
end
