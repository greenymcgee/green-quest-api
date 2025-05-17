require "test_helper"

class Api::Games::GameEngineGameRefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @create_facade =
      Api::Games::GameEngineGameCreateFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    @refresh_facade =
      Api::Games::GameEngineGameRefreshFacade.new(
        game: @game,
        igdb_game_data: igdb_game_data,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
  end

  test "should refresh game game_engine data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_engines_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_game_engines
    igdb_game_data["game_engines"].each do |id|
      game_engine_json =
        JSON.parse(json_mocks("igdb/game_engines/#{id}.refresh.json"))
      game_game_engine = @game.game_engines.find_by(igdb_id: id)
      game_engine_logo_json =
        JSON.parse(
          json_mocks(
            "igdb/game_engine_logos/#{game_game_engine.game_engine_logo.igdb_id}.refresh.json",
          ),
        )
      assert_equal game_engine_json.first["slug"], game_game_engine.slug
      assert game_engine_logo_json.first["url"].include? "refresh"
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_engines_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_game_engines
    assert_equal igdb_game_data["game_engines"].count, @game.game_engines.count
    assert_equal @game.game_engines.distinct.count, @game.game_engines.count
  end
end
