class Api::GamesController < ApplicationController
  before_action :set_game, only: %i[show update destroy]

  # 200
  def index
    @games = Game.all
  end

  # 200, 404
  def show
  end

  # 200, 400, 401, 403
  def create
    authenticate_user!
    @game = Game.new(game_params)
    authorize @game

    request_igdb_game_data

    if @igdb_game_request_error
      return(
        render json: @igdb_game_request_error, status: :unprocessable_entity
      )
    end

    if @game.update(game_params) && populate_igdb_fields
      return render_successful_show_response(:created)
    end

    render json: @game.errors, status: :unprocessable_entity
  end

  # 200, 400, 401, 403, 404
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

  def populate_igdb_fields
    facade = Api::Games::IgdbFieldsFacade.new(@game, @igdb_game_data)
    facade.populate_game_fields
  end

  def request_igdb_game_data
    facade = Api::Games::GameRequestFacade.new(@game.igdb_id)
    game_request = facade.get_igdb_game_data
    @igdb_game_data = game_request[:igdb_game_data]
    @twitch_bearer_token = game_request[:twitch_bearer_token]
    @igdb_game_request_error = game_request[:error]
  end

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
