class Api::Games::GenreGameCreateFacade
  attr_reader :game
  attr_reader :igdb_game_data
  attr_reader :twitch_bearer_token

  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @game = game
    @igdb_game_data = igdb_game_data
    @twitch_bearer_token = twitch_bearer_token
  end

  def add_genres_to_game
    set_genres_response
    add_genres_errors_to_game
    @genres_response[:resources].each { |genre| game.genres << genre }
  end

  private

  def set_genres_response
    facade =
      IgdbCreateFacade.new(
        fields_facade: Api::Genres::IgdbFieldsFacade,
        ids: igdb_game_data["genres"],
        model: Genre,
        twitch_bearer_token: twitch_bearer_token,
      )
    @genres_response = facade.find_or_create_resources
  end

  def add_genres_errors_to_game
    return false unless @genres_response[:errors].present?

    game.errors.add(:genres, @genres_response[:errors])
  end
end
