class Api::Games::PlayerPerspectiveGameRefreshFacade < Api::Games::PlayerPerspectiveGameCreateFacade
  def refresh_game_player_perspectives
    set_player_perspectives_response
    add_player_perspectives_errors_to_game
    @player_perspectives_response[:resources].each do |player_perspective|
      next if game.player_perspectives.exists?(id: player_perspective.id)

      game.player_perspectives << player_perspective
    end
  end

  private

  def set_player_perspectives_response
    @player_perspectives_response =
      IgdbRefreshFacade.new(
        fields_facade: Api::PlayerPerspectives::IgdbFieldsFacade,
        ids: igdb_game_data["player_perspectives"],
        model: PlayerPerspective,
        twitch_bearer_token: twitch_bearer_token,
      ).find_or_create_resources
  end
end
