require "test_helper"

class Api::Games::ReleaseDateGameRefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    params = {
      game: @game,
      igdb_game_data: @igdb_game_data,
      twitch_bearer_token: @twitch_bearer_token,
    }
    @create_facade = Api::Games::ReleaseDateGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::ReleaseDateGameRefreshFacade.new(**params)
    @platform_facade =
      Api::Games::PlatformGameCreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should refresh game release_date data" do
    stub_successful_game_create_request(@game.igdb_id)
    @platform_facade.add_platforms_to_game
    @create_facade.add_release_dates_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_release_dates
    igdb_game_data["release_dates"].each do |id|
      release_date_json =
        JSON.parse(json_mocks("igdb/release_dates/#{id}.refresh.json"))
      game_release_date = @game.release_dates.find_by(igdb_id: id)
      assert_equal(
        release_date_json.first["checksum"],
        game_release_date.checksum,
      )
    end
  end
end
