class Api::Games::ScreenshotGameRefreshFacade < Api::Games::ScreenshotGameCreateFacade
  def refresh_game_screenshots
    set_screenshots_response
    add_screenshots_errors_to_game
  end

  private

  def set_screenshots_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Igdb::ImageFieldsFacade,
        ids: igdb_game_data["screenshots"],
        model: Screenshot,
        twitch_bearer_token: twitch_bearer_token,
      )
    @screenshots_response =
      facade.find_or_create_resources(update_screenshot_game)
  end

  def update_screenshot_game
    ->(screenshot) do
      return if screenshot.game.present?

      screenshot.game = game
    end
  end
end
