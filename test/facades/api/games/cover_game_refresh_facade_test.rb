require "test_helper"

class Api::Games::CoverGameRefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = igdb_game_data
    @twitch_bearer_token = stubbed_twitch_bearer_token
    params = {
      game: @game,
      igdb_game_data: @igdb_game_data,
      twitch_bearer_token: @twitch_bearer_token,
    }
    @create_facade = Api::Games::CoverGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::CoverGameRefreshFacade.new(**params)
  end

  test "should refresh game cover data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_cover_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_cover
    cover_json =
      JSON.parse(
        json_mocks("igdb/covers/#{igdb_game_data["cover"]}.refresh.json"),
      )
    assert_equal cover_json.first["url"], @game.cover.reload.url
  end
end
