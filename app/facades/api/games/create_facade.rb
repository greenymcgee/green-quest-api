class Api::Games::CreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_game_resources
    add_genres_to_game
  end

  private

  def set_genre_response
    facade =
      Api::Genres::CreateFacade.new(
        @@igdb_game_data["genres"],
        @@twitch_bearer_token,
      )
    @@genre_response = facade.find_or_create_genres
  end

  def add_genre_errors_to_game
    return unless @@genre_response[:errors].present?

    @@game.errors.add(:genres, @@genre_response[:errors])
  end

  def add_genres_to_game
    set_genre_response
    add_genre_errors_to_game
    @@genre_response[:genres].each { |genre| @@game.genres << genre }
  end
end
