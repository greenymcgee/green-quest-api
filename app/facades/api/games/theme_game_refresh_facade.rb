class Api::Games::ThemeGameRefreshFacade < Api::Games::ThemeGameCreateFacade
  def refresh_game_themes
    set_themes_response
    add_themes_errors_to_game
    @themes_response[:resources].each do |theme|
      next if game.themes.exists?(id: theme.id)

      game.themes << theme
    end
  end

  private

  def set_themes_response
    @themes_response =
      IgdbRefreshFacade.new(
        fields_facade: Api::Themes::IgdbFieldsFacade,
        ids: igdb_game_data["themes"],
        model: Theme,
        twitch_bearer_token: twitch_bearer_token,
      ).find_or_create_resources
  end
end
