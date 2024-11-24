class Api::GamesController < ApplicationController
  before_action :set_game, only: %i[show update destroy]

  # 200
  def index
    @games = Game.all
  end

  # 200, 404
  def show
  end

  # 200, 207, 400, 401, 403
  def create
    authenticate_user!
    @game = Game.new(game_create_params)
    authorize @game
    request_igdb_game_data
    return render_igdb_game_request_failure if @igdb_game_request_error.present?

    return render_unprocessable_game unless populate_igdb_fields

    add_game_resources
    return render_successful_show_response(:multi_status) if errors_present?

    render_successful_show_response(:created)
  end

  # 200, 400, 401, 403, 404
  def update
    authenticate_user!
    authorize @game
    if @game.update(game_update_params)
      return render_successful_show_response(:ok)
    end

    render json: @game.errors, status: :unprocessable_entity
  end

  # 200, 401, 403, 404
  def destroy
    authenticate_user!
    authorize @game
    @game.destroy!
  end

  private

  def populate_igdb_fields
    facade = Api::Games::IgdbFieldsFacade.new(@game, @igdb_game_data)
    facade.populate_game_fields
  end

  def request_igdb_game_data
    facade = Api::Games::IgdbRequestFacade.new(@game.igdb_id)
    game_request = facade.get_igdb_game_data
    @igdb_game_data = game_request[:igdb_game_data]
    @twitch_bearer_token = game_request[:twitch_bearer_token]
    @igdb_game_request_error = game_request[:error]
  end

  def set_game
    @game = Game.find(params[:id])
  end

  def game_update_params
    params.require(:game).permit(:rating, :review)
  end

  def game_create_params
    params.require(:game).permit(:igdb_id, :rating, :review)
  end

  def render_successful_show_response(status)
    render :show, status: status, location: api_game_url(@game)
  end

  def render_igdb_game_request_failure
    render json: @igdb_game_request_error, status: :unprocessable_entity
  end

  def render_unprocessable_game
    render json: @game.errors, status: :unprocessable_entity
  end

  def errors_present?
    @game.errors.present?
  end

  def add_game_resources
    Api::Games::CreateFacade.new(
      game: @game,
      igdb_game_data: @igdb_game_data,
      twitch_bearer_token: @twitch_bearer_token,
    ).add_game_resources
  end
end
