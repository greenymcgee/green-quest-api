require "test_helper"

class Api::Games::RefreshFacadeTest < ActionDispatch::IntegrationTest
  include GameCreateTestHelper
  include GameRefreshTestHelper

  setup do
    @game = Game.create(igdb_id: 1026)
    @igdb_game_data = JSON.parse(json_mocks("igdb/game.json")).first
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @create_facade =
      Api::Games::CreateFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
    @refresh_facade =
      Api::Games::RefreshFacade.new(
        game: @game,
        igdb_game_data: @igdb_game_data,
        twitch_bearer_token: @twitch_bearer_token,
      )
  end

  test "should refresh game platforms" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.platforms.each do |platform|
      assert platform.slug.include?("refreshed")
    end
  end

  test "should refresh involved companies" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_game_resources
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_resources
    @game.involved_companies.each do |involved_company|
      assert involved_company.checksum.include?("refresh")
    end
  end
end
