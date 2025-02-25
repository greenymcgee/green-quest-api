require "./app/facades/api/games/involved_company_game_create_facade.rb"

class Api::Games::CreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
    @@create_facade_params = {
      game: @@game,
      igdb_game_data: @@igdb_game_data,
      twitch_bearer_token: @@twitch_bearer_token,
    }
  end

  def add_game_resources
    add_cover_to_game
    add_franchises_to_game
    add_game_engines_to_game
    add_game_modes_to_game
    add_game_videos_to_game
    add_genres_to_game
    add_platforms_to_game
    add_player_perspectives_to_game
    Api::Games::InvolvedCompanyGameCreateFacade.new(
      **@@create_facade_params,
    ).add_involved_companies_to_game
    Api::Games::AgeRatingGameCreateFacade.new(
      **@@create_facade_params,
    ).add_age_ratings_to_game
    Api::Games::ArtworkGameCreateFacade.new(
      **@@create_facade_params,
    ).add_artworks_to_game
    Api::Games::ScreenshotGameCreateFacade.new(
      **@@create_facade_params,
    ).add_screenshots_to_game
    add_themes_to_game
    add_release_dates_to_game
    add_websites_to_game
  end

  private

  def add_cover_to_game
    Api::Games::CoverGameCreateFacade.new(
      **@@create_facade_params,
    ).add_cover_to_game
  end

  def add_franchises_to_game
    Api::Games::FranchiseGameCreateFacade.new(
      **@@create_facade_params,
    ).add_franchises_to_game
  end

  def add_game_engines_to_game
    Api::Games::GameEngineGameCreateFacade.new(
      **@@create_facade_params,
    ).add_game_engines_to_game
  end

  def add_game_modes_to_game
    Api::Games::GameModeGameCreateFacade.new(
      **@@create_facade_params,
    ).add_game_modes_to_game
  end

  def add_genres_to_game
    Api::Games::GenreGameCreateFacade.new(
      **@@create_facade_params,
    ).add_genres_to_game
  end

  def add_platforms_to_game
    Api::Games::PlatformGameCreateFacade.new(
      **@@create_facade_params,
    ).add_platforms_to_game
  end

  def add_player_perspectives_to_game
    Api::Games::PlayerPerspectiveGameCreateFacade.new(
      **@@create_facade_params,
    ).add_player_perspectives_to_game
  end

  def add_release_dates_to_game
    Api::Games::ReleaseDateGameCreateFacade.new(
      **@@create_facade_params,
    ).add_release_dates_to_game
  end

  def add_themes_to_game
    Api::Games::ThemeGameCreateFacade.new(
      **@@create_facade_params,
    ).add_themes_to_game
  end

  def add_websites_to_game
    Api::Games::WebsiteGameCreateFacade.new(
      **@@create_facade_params,
    ).add_websites_to_game
  end

  def add_game_videos_to_game
    Api::Games::GameVideoGameCreateFacade.new(
      **@@create_facade_params,
    ).add_game_videos_to_game
  end
end
