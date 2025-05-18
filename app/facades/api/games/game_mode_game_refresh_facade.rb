class Api::Games::GameModeGameRefreshFacade < Api::Games::GameModeGameCreateFacade
  def refresh_game_game_modes
    set_game_modes_response
    add_game_modes_errors_to_game
    @game_modes_response[:resources].each do |game_mode|
      next if game.game_modes.exists?(id: game_mode.id)

      game.game_modes << game_mode
    end
  end

  private

  def set_game_modes_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Api::GameModes::IgdbFieldsFacade,
        ids: igdb_game_data["game_modes"],
        model: GameMode,
        twitch_bearer_token: twitch_bearer_token,
      )
    @game_modes_response = facade.find_or_create_resources
  end
end
