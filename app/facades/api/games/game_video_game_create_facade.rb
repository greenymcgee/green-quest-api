class Api::Games::GameVideoGameCreateFacade
  def initialize(game:, igdb_game_data:, twitch_bearer_token:)
    @@game = game
    @@igdb_game_data = igdb_game_data
    @@twitch_bearer_token = twitch_bearer_token
  end

  def add_game_videos_to_game
    set_game_videos_response
    add_game_videos_errors_to_game
  end

  private

  def set_game_videos_response
    facade =
      IgdbCreateFacade.new(
        fields_facade: Api::GameVideos::IgdbFieldsFacade,
        ids: @@igdb_game_data["videos"],
        model: GameVideo,
        twitch_bearer_token: @@twitch_bearer_token,
      )
    @@game_videos_response =
      facade.find_or_create_resources(
        ->(game_video) { game_video.game = @@game },
      )
  end

  def add_game_videos_errors_to_game
    return false unless @@game_videos_response[:errors].present?

    @@game.errors.add(:game_videos, @@game_videos_response[:errors])
  end
end
