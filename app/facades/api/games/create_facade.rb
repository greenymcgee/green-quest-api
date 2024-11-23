class Api::Games::CreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_game_resources
    add_genres_to_game
    add_platforms_to_game
    add_involved_companies_to_game
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

  def set_involved_companies_response
    facade =
      Api::InvolvedCompanies::CreateFacade.new(
        game: @@game,
        ids: @@igdb_game_data["involved_companies"],
        twitch_bearer_token: @@twitch_bearer_token,
      )
    @@involved_companies_response = facade.find_or_create_involved_companies
  end

  def add_involved_companies_errors_to_game
    unless @@involved_companies_response[:errors][:involved_companies].present?
      return
    end

    @@game.errors.add(
      :involved_companies,
      @@involved_companies_response[:errors][:involved_companies],
    )
  end

  def add_companies_errors_to_game
    return unless @@involved_companies_response[:errors][:companies].present?

    @@game.errors.add(
      :companies,
      @@involved_companies_response[:errors][:companies],
    )
  end

  def add_involved_companies_to_game
    set_involved_companies_response
    add_involved_companies_errors_to_game
    add_companies_errors_to_game
    @@involved_companies_response[
      :involved_companies
    ].each { |involved_company| @@game.involved_companies << involved_company }
  end
end
