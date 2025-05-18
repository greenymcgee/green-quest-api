class Api::Games::RefreshFacade
  attr_reader :game
  attr_reader :igdb_game_data
  attr_reader :twitch_bearer_token

  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @game = game
    @igdb_game_data = igdb_game_data
    @twitch_bearer_token = twitch_bearer_token
    @refresh_facade_params = {
      game: game,
      igdb_game_data: igdb_game_data,
      twitch_bearer_token: twitch_bearer_token,
    }
  end

  def refresh_game_resources
    refresh_age_ratings
    refresh_artworks
    refresh_cover
    refresh_franchises
    refresh_game_engines
    refresh_game_modes
    refresh_game_videos
    refresh_genres
    refresh_involved_companies
    refresh_platforms
  end

  private

  def refresh_age_ratings
    Api::Games::AgeRatingGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_age_ratings
  end

  def refresh_artworks
    Api::Games::ArtworkGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_artworks
  end

  def refresh_cover
    Api::Games::CoverGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_cover
  end

  def refresh_franchises
    Api::Games::FranchiseGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_franchises
  end

  def refresh_game_engines
    Api::Games::GameEngineGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_game_engines
  end

  def refresh_game_modes
    Api::Games::GameModeGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_game_modes
  end

  def refresh_game_videos
    Api::Games::GameVideoGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_game_videos
  end

  def refresh_genres
    Api::Games::GenreGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_genres
  end

  def refresh_involved_companies
    Api::Games::InvolvedCompanyGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_involved_companies
  end

  def refresh_platforms
    Api::Games::PlatformGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_platforms
  end
end
