require "test_helper"

class IgdbApiFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer 132sdlfkj"
    @pathname = pathname = "games/40"
    @game_json = json_mocks("igdb/game.json")
  end

  test "should return game data upon success" do
    stub_successful_igdb_api_request(@pathname, @game_json, @twitch_oauth_token)
    facade = IgdbApiFacade.new(@pathname, @twitch_oauth_token)
    response = facade.get_igdb_api_resource[:response]
    assert_equal(response.body, @game_json)
  end

  test "should return an error when the request fails" do
    stub_igdb_api_request_failure(@pathname)
    facade = IgdbApiFacade.new(@pathname, @twitch_oauth_token)
    error = facade.get_igdb_api_resource[:error]
    assert_equal(error.to_json, igdb_api_error.to_json)
  end
end
