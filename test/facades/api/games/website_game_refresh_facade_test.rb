require "test_helper"

class Api::Games::WebsiteGameRefreshFacadeTest < ActionDispatch::IntegrationTest
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
    @create_facade = Api::Games::WebsiteGameCreateFacade.new(**params)
    @refresh_facade = Api::Games::WebsiteGameRefreshFacade.new(**params)
  end

  test "should refresh game website data" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_websites_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_websites
    igdb_game_data["websites"].each do |id|
      website_json = JSON.parse(json_mocks("igdb/websites/#{id}.refresh.json"))
      game_website = @game.websites.find_by(igdb_id: id)
      assert_equal website_json.first["checksum"], game_website.checksum
    end
  end

  test "should not duplicate associations on refresh" do
    stub_successful_game_create_request(@game.igdb_id)
    @create_facade.add_websites_to_game
    stub_successful_game_refresh_request(@game.igdb_id)
    @refresh_facade.refresh_game_websites
    assert_equal igdb_game_data["websites"].count, @game.websites.count
    assert_equal @game.websites.distinct.count, @game.websites.count
  end
end
