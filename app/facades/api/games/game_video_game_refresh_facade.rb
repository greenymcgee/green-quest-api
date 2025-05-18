class Api::Games::GameVideoGameRefreshFacade < Api::Games::GameVideoGameCreateFacade
  def refresh_game_game_videos
    set_game_videos_response
    add_game_videos_errors_to_game
  end

  private

  def set_game_videos_response
    facade =
      IgdbRefreshFacade.new(
        fields_facade: Api::GameVideos::IgdbFieldsFacade,
        ids: igdb_game_data["videos"],
        model: GameVideo,
        twitch_bearer_token: twitch_bearer_token,
      )
    @game_videos_response =
      facade.find_or_create_resources(
        ->(game_video) do
          return if game.game_videos.exists?(id: game_video.id)

          game_video.game = game
        end,
      )
  end
end
