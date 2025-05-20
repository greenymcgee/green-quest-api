class Api::Games::ReleaseDateGameCreateFacade
  attr_reader :game
  attr_reader :igdb_game_data
  attr_reader :twitch_bearer_token

  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @game = game
    @igdb_game_data = igdb_game_data
    @twitch_bearer_token = twitch_bearer_token
  end

  def add_release_dates_to_game
    set_release_dates_response
    add_release_dates_errors_to_game
  end

  private

  def set_release_dates_response
    facade =
      IgdbCreateFacade.new(
        fields_facade: Api::ReleaseDates::IgdbFieldsFacade,
        ids: igdb_game_data["release_dates"],
        model: ReleaseDate,
        twitch_bearer_token: twitch_bearer_token,
      )
    @release_dates_response =
      facade.find_or_create_resources(update_release_date_game)
  end

  def update_release_date_game
    ->(release_date) { release_date.game = game }
  end

  def add_release_dates_errors_to_game
    return false unless @release_dates_response[:errors].present?

    game.errors.add(:release_dates, @release_dates_response[:errors])
  end
end
