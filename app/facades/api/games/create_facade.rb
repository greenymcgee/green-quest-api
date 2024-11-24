require "./app/facades/api/games/involved_company_game_create_facade.rb"

class Api::Games::CreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_game_resources
    add_genres_to_game
    add_platforms_to_game
    Api::Games::InvolvedCompanyGameCreateFacade.new(
      game: @@game,
      igdb_game_data: @@igdb_game_data,
      twitch_bearer_token: @@twitch_bearer_token,
    ).add_involved_companies_to_game
    Api::Games::AgeRatingGameCreateFacade.new(
      game: @@game,
      igdb_game_data: @@igdb_game_data,
      twitch_bearer_token: @@twitch_bearer_token,
    ).add_age_ratings_to_game
    Api::Games::ArtworkGameCreateFacade.new(
      game: @@game,
      igdb_game_data: @@igdb_game_data,
      twitch_bearer_token: @@twitch_bearer_token,
    ).add_artworks_to_game
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

  def set_platforms_response
    facade =
      Api::Platforms::CreateFacade.new(
        @@igdb_game_data["platforms"],
        @@twitch_bearer_token,
      )
    @@platforms_response = facade.find_or_create_platforms
  end

  def add_platforms_errors_to_game
    return unless @@platforms_response[:errors].present?

    @@game.errors.add(:platforms, @@platforms_response[:errors])
  end

  def add_platforms_to_game
    set_platforms_response
    add_platforms_errors_to_game
    @@platforms_response[:platforms].each do |platform|
      @@game.platforms << platform
    end
  end
end
