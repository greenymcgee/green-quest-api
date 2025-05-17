class Api::Games::GameEngineGameRefreshFacade < Api::Games::GameEngineGameCreateFacade
  def refresh_game_game_engines
    set_game_engines_response
    add_game_engines_errors_to_game
    add_game_engine_logos_errors_to_game
    @game_engines_response[:game_engines].each do |game_engine|
      next if game.game_engines.exists?(id: game_engine.id)

      game.game_engines << game_engine
    end
  end

  private

  def set_game_engines_response
    facade =
      Api::GameEngines::RefreshFacade.new(
        igdb_game_data["game_engines"],
        twitch_bearer_token,
      )
    @game_engines_response = facade.find_or_create_game_engines
  end
end
