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
    refresh_game_artworks
    refresh_game_engines
    refresh_involved_companies
    refresh_platforms
  end

  private

  def refresh_game_artworks
    Api::Games::ArtworkGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_artworks
  end

  def refresh_game_engines
    Api::Games::GameEngineGameRefreshFacade.new(
      **@refresh_facade_params,
    ).refresh_game_game_engines
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
