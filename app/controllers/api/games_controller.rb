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
    @game = Game.new(game_params)
    authorize @game

    request_igdb_game_data

    return render_igdb_game_request_failure if @igdb_game_request_error.present?

    return render_unprocessible_game unless game_saved?

    set_genre_response
    add_genres_to_game
    add_genre_errors_to_game
    return render_successful_show_response(:multi_status) if errors_present?

    render_successful_show_response(:created)
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
    facade = Api::Games::IgdbRequestFacade.new(@game.igdb_id)
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

  def game_saved?
    @game.update(game_params) && populate_igdb_fields
  end

  def render_successful_show_response(status)
    render :show, status: status, location: api_game_url(@game)
  end

  def render_igdb_game_request_failure
    render json: @igdb_game_request_error, status: :unprocessable_entity
  end

  def render_unprocessible_game
    render json: @game.errors, status: :unprocessable_entity
  end

  def errors_present?
    @game.errors.present?
  end

  def set_genre_response
    facade =
      Api::Genres::CreateFacade.new(
        @igdb_game_data["genres"],
        @twitch_bearer_token,
      )
    @genre_response = facade.find_or_create_genres
  end

  def add_genres_to_game
    @genre_response[:genres].each { |genre| @game.genres << genre }
  end

  def add_genre_errors_to_game
    return unless @genre_response[:errors].present?

    @game.errors.add(:genres, @genre_response[:errors])
  end
end
