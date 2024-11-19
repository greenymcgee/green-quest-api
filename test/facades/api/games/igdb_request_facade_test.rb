require "test_helper"

class Api::Games::IgdbRequestFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  setup do
    @twitch_oauth_token = "Bearer #{twitch_oauth_access_token}"
    @pathname = pathname = "games/1026"
    @game_json = json_mocks("igdb/game.json")
  end

  test "should return game data upon success" do
    stub_successful_igdb_api_request(@pathname, @game_json, @twitch_oauth_token)
    stub_successful_twitch_oauth_request
    facade = Api::Games::IgdbRequestFacade.new(1026)
    game = facade.get_igdb_game_data[:igdb_game_data]
    assert_equal(game, JSON.parse(@game_json).first)
  end

  test "should return bearer token upon success" do
    stub_successful_igdb_api_request(@pathname, @game_json, @twitch_oauth_token)
    stub_successful_twitch_oauth_request
    facade = Api::Games::IgdbRequestFacade.new(1026)
    token = facade.get_igdb_game_data[:twitch_bearer_token]
    assert_equal(token, @twitch_oauth_token)
  end

  test "should return an error when the twitch oauth request fails" do
    stub_twitch_oauth_request_failure
    facade = Api::Games::IgdbRequestFacade.new(1026)
    error = facade.get_igdb_game_data[:error]
    assert_equal(error.to_json, twitch_oauth_error.to_json)
  end

  test "should return an error when the game request fails" do
    stub_successful_twitch_oauth_request
    stub_igdb_api_request_failure(@pathname)
    facade = Api::Games::IgdbRequestFacade.new(1026)
    error = facade.get_igdb_game_data[:error]
    assert_equal(error.to_json, igdb_api_error.to_json)
  end
end
