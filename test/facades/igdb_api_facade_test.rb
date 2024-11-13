require "test_helper"

class IgdbApiFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = twitch_oauth_bearer_token
    @pathname = pathname = "games/40"
    @request_body = { fields: "*" }
    @game_json = json_mocks("igdb/game.json")
  end

  test "should return game data upon success" do
    stub_successful_igdb_api_request(@pathname, @game_json)
    facade = IgdbApiFacade.new(@pathname, @twitch_oauth_token)
    response = facade.get_igdb_api_resource
    assert_equal(response.body, @game_json)
  end

  test "should return an error when the request fails" do
    stub_igdb_api_request_failure(@pathname)
    facade = IgdbApiFacade.new(@pathname, @twitch_oauth_token)
    response = facade.get_igdb_api_resource
    expectation = StandardError.new(igdb_api_failure_response_body).message
    assert_equal(response.message, expectation)
  end
end
