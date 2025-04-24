class Api::GamesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include Pagy::Backend

  before_action :set_game, only: %i[show update destroy]

  # 200
  def index
    @pagy, @games =
      pagy(
        Game
          .by_query(params[:query])
          .by_companies(params[:companies])
          .by_genres(params[:genres])
          .by_platforms(params[:platforms])
          .includes(%i[cover platforms])
          .order(name: :asc),
      )
    @pagy_metadata = pagy_metadata(@pagy)
  end

  # 200, 404
  def show
    unless @game.present?
      render(
        json: {
          message: "No games found matching #{params[:slug]}",
        },
        status: :not_found,
      )
    end
  end

  # 200, 207, 400, 401, 403
  def create
    authenticate_user!
    @game = Game.new(game_create_params)
    authorize @game

    begin
      request_igdb_game_data
      if @igdb_game_request_error.present?
        return render_igdb_game_request_failure
      end

      return render_unprocessable_game unless populate_igdb_fields

      add_game_resources
      return render_successful_show_response(:multi_status) if errors_present?

      render_successful_show_response(:created)
    rescue StandardError => error
      if error.message.include? "duplicate"
        preexisting_game = Game.find_by(igdb_id: game_create_params[:igdb_id])
        return(
          render(
            json: {
              message: "#{preexisting_game.name} already exists",
            },
            status: :unprocessable_entity,
          )
        )
      end

      raise StandardError.new(error)
    end
  end

  # 200, 400, 401, 403, 404
  def update
    authenticate_user!
    authorize @game
    update_params = game_update_params
    review = update_params.delete(:review)
    @game.assign_attributes(update_params)
    @game.review = sanitize(review) || ""
    Game.unset_currently_playing! if update_params[:currently_playing]
    return render_successful_show_response(:ok) if @game.save!

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
    @game = Game.find_by(slug: params[:slug])
  end

  def game_update_params
    params.require(:game).permit(
      :banner_image,
      :currently_playing,
      :featured_video_id,
      :published_at,
      :rating,
      :review,
    )
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
