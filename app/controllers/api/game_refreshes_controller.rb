class Api::GameRefreshesController < ApplicationController
  def create
    authenticate_user!
    set_game
    request_igdb_game_data
    return render_igdb_game_request_failure if @igdb_game_request_error.present?

    return render_unprocessable_game unless populate_igdb_fields

    add_game_resources
    return render_partial_refresh if errors_present?

    render_successful_show_response(:created)
  end

  private

  def set_game
    @game = authorize Game.find_by!(slug: params[:slug])
  end

  def request_igdb_game_data
    facade = Api::Games::IgdbRequestFacade.new(@game.igdb_id)
    game_request = facade.get_igdb_game_data
    @igdb_game_data = game_request[:igdb_game_data]
    @twitch_bearer_token = game_request[:twitch_bearer_token]
    @igdb_game_request_error = game_request[:error]
  end

  def render_igdb_game_request_failure
    render json: @igdb_game_request_error, status: :unprocessable_entity
  end

  def render_partial_refresh
    Rails.logger.warn(
      "[GameRefresh] Partial success refreshing game #{@game.slug}: " \
        "#{@game.errors.full_messages.join("; ")}",
    )
    render_successful_show_response(:multi_status)
  end

  def render_successful_show_response(status)
    render "api/games/show", status: status, location: api_game_url(@game)
  end

  def render_unprocessable_game
    render json: @game.errors, status: :unprocessable_entity
  end

  def errors_present?
    @game.errors.present?
  end

  def add_game_resources
    Api::Games::RefreshFacade.new(
      game: @game,
      igdb_game_data: @igdb_game_data,
      twitch_bearer_token: @twitch_bearer_token,
    ).refresh_game_resources
  end

  def populate_igdb_fields
    facade = Api::Games::IgdbFieldsFacade.new(@game, @igdb_game_data)
    facade.populate_game_fields
  end
end
