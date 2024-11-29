class Api::Games::GameEngineGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_game_engines_to_game
    set_game_engines_response
    add_game_engines_errors_to_game
    add_game_engine_logos_errors_to_game
    @@game_engines_response[:game_engines].each do |game_engine|
      @@game.game_engines << game_engine
    end
  end

  private

  def set_game_engines_response
    facade =
      Api::GameEngines::CreateFacade.new(
        @@igdb_game_data["game_engines"],
        @@twitch_bearer_token,
      )
    @@game_engines_response = facade.find_or_create_game_engines
  end

  def add_game_engines_errors_to_game
    return unless @@game_engines_response[:errors][:game_engines].present?

    @@game.errors.add(
      :game_engines,
      @@game_engines_response[:errors][:game_engines],
    )
  end

  def add_game_engine_logos_errors_to_game
    return unless @@game_engines_response[:errors][:game_engine_logos].present?

    @@game.errors.add(
      :game_engine_logos,
      @@game_engines_response[:errors][:game_engine_logos],
    )
  end
end
