require "test_helper"

class Api::Games::PlatformGameRefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @create_facade =
      Api::Games::PlatformGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    @refresh_facade =
      Api::Games::PlatformGameRefreshFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should refresh game platform data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_platforms_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_platforms
    igdb_game_data["platforms"].each do |id|
      platform_json =
        JSON.parse(json_mocks("igdb/platforms/#{id}.refresh.json"))
      game_platform = @game.platforms.find_by(igdb_id: id)
      platform_logo_json =
        JSON.parse(
          json_mocks(
            "igdb/platform_logos/#{game_platform.platform_logo.igdb_id}.refresh.json",
          ),
        )
      assert_equal platform_json.first["slug"], game_platform.slug
      assert platform_logo_json.first["url"].include? "refresh"
    end
  end
end
