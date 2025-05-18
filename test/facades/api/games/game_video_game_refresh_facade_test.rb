require "test_helper"

class Api::Games::GameVideoGameRefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @create_facade =
      Api::Games::GameVideoGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    @refresh_facade =
      Api::Games::GameVideoGameRefreshFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should refresh game game_video data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_videos_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_game_videos
    igdb_game_data["videos"].each do |id|
      game_video_json =
        JSON.parse(json_mocks("igdb/game_videos/#{id}.refresh.json"))
      game_game_video = @game.game_videos.find_by(igdb_id: id)
      assert_equal game_video_json.first["checksum"], game_game_video.checksum
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_videos_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_game_videos
    assert_equal igdb_game_data["videos"].count, @game.game_videos.count
    assert_equal @game.game_videos.distinct.count, @game.game_videos.count
  end
end
