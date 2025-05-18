require "test_helper"

class Api::Games::GameModeGameRefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @create_facade =
      Api::Games::GameModeGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    @refresh_facade =
      Api::Games::GameModeGameRefreshFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should refresh game game_mode data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_modes_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_game_modes
    igdb_game_data["game_modes"].each do |id|
      game_mode_json =
        JSON.parse(json_mocks("igdb/game_modes/#{id}.refresh.json"))
      game_game_mode = @game.game_modes.find_by(igdb_id: id)
      assert_equal game_mode_json.first["slug"], game_game_mode.slug
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_modes_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_game_modes
    assert_equal igdb_game_data["game_modes"].count, @game.game_modes.count
    assert_equal @game.game_modes.distinct.count, @game.game_modes.count
  end
end
