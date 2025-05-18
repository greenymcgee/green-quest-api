require "test_helper"

class Api::Games::FranchiseGameRefreshFacadeTest < ActionDispatch::IntegrationTest
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
    @create_facade = Api::Games::FranchiseGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::FranchiseGameRefreshFacade.new(**params)
  end

  test "should refresh game franchise data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_franchises_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_franchises
    igdb_game_data["franchises"].each do |id|
      franchise_json =
        JSON.parse(json_mocks("igdb/franchises/#{id}.refresh.json"))
      game_franchise = @game.franchises.find_by(igdb_id: id)
      assert_equal franchise_json.first["slug"], game_franchise.slug
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_franchises_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_franchises
    assert_equal igdb_game_data["franchises"].count, @game.franchises.count
    assert_equal @game.franchises.distinct.count, @game.franchises.count
  end
end
