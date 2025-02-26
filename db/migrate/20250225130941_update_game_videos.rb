class UpdateGameVideos < ActiveRecord::Migration[8.0]
  def change
    twitch_oauth_response = TwitchOauthFacade.get_twitch_oauth_token
    token = twitch_oauth_response[:bearer_token]

    Game.all.each do |game|
      response =
        IgdbRequestFacade.new(
          igdb_id: game.igdb_id,
          pathname: "games",
          twitch_bearer_token: token,
        ).get_igdb_data
      video_ids = response[:igdb_data]["videos"]
      video_ids&.each do |video_id|
        Api::Games::GameVideoGameCreateFacade.new(
          game: game,
          igdb_game_data: response[:igdb_data],
          twitch_bearer_token: token,
        ).add_game_videos_to_game
      end
    end
  end
end
