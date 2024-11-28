class Api::Games::PlatformGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_platforms_to_game
    set_platforms_response
    add_platforms_errors_to_game
    add_platform_logos_errors_to_game
    @@platforms_response[:platforms].each do |platform|
      @@game.platforms << platform
    end
  end

  private

  def set_platforms_response
    facade =
      Api::Platforms::CreateFacade.new(
        @@igdb_game_data["platforms"],
        @@twitch_bearer_token,
      )
    @@platforms_response = facade.find_or_create_platforms
  end

  def add_platforms_errors_to_game
    return unless @@platforms_response[:errors][:platforms].present?

    @@game.errors.add(:platforms, @@platforms_response[:errors][:platforms])
  end

  def add_platform_logos_errors_to_game
    return unless @@platforms_response[:errors][:platform_logos].present?

    @@game.errors.add(
      :platform_logos,
      @@platforms_response[:errors][:platform_logos],
    )
  end
end
