class Api::Games::PlatformGameRefreshFacade < Api::Games::PlatformGameCreateFacade
  def refresh_game_platforms
    set_platforms_response
    add_platforms_errors_to_game
    add_platform_logos_errors_to_game
    @platforms_response[:platforms].each do |platform|
      next if game.platforms.exists?(id: platform.id)

      game.platforms << platform
    end
  end

  private

  def set_platforms_response
    facade =
      Api::Platforms::RefreshFacade.new(
        igdb_game_data["platforms"],
        twitch_bearer_token,
      )
    @platforms_response = facade.find_or_create_platforms
  end
end
