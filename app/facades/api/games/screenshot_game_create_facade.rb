class Api::Games::ScreenshotGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_screenshots_to_game
    set_screenshots_response
    add_screenshots_errors_to_game
  end

  private

  def set_screenshots_response
    facade =
      IgdbCreateFacade.new(
        fields_facade: Api::Screenshots::IgdbFieldsFacade,
        ids: @@igdb_game_data["screenshots"],
        model: Screenshot,
        twitch_bearer_token: @@twitch_bearer_token,
      )
    @@screenshots_response =
      facade.find_or_create_resources(update_screenshot_game)
  end

  def update_screenshot_game
    ->(screenshot) { screenshot.game = @@game }
  end

  def add_screenshots_errors_to_game
    return false unless @@screenshots_response[:errors].present?

    @@game.errors.add(:screenshots, @@screenshots_response[:errors])
  end
end
