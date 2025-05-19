require "test_helper"

class Api::Games::PlayerPerspectiveGameRefreshFacadeTest < ActionDispatch::IntegrationTest
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
    @create_facade = Api::Games::PlayerPerspectiveGameCreateFacade.new(**params)
    @refresh_facade =
      Api::Games::PlayerPerspectiveGameRefreshFacade.new(**params)
  end

  test "should refresh game player_perspective data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_player_perspectives_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_player_perspectives
    igdb_game_data["player_perspectives"].each do |id|
      player_perspective_json =
        JSON.parse(json_mocks("igdb/player_perspectives/#{id}.refresh.json"))
      game_player_perspective = @game.player_perspectives.find_by(igdb_id: id)
      assert_equal(
        player_perspective_json.first["slug"],
        game_player_perspective.slug,
      )
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_player_perspectives_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_player_perspectives
    assert_equal(
      igdb_game_data["player_perspectives"].count,
      @game.player_perspectives.count,
    )
    assert_equal(
      @game.player_perspectives.distinct.count,
      @game.player_perspectives.count,
    )
  end
end
