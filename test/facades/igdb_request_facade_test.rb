require "test_helper"

class IgdbRequestFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_bearer_token = "Bearer asdlfkh"
    @igdb_id = 74_574
    @pathname = "games"
    @game_json = json_mocks("igdb/game.json")
    @full_pathname = "#{@pathname}/#{@igdb_id}"
  end

  test "should return IGDB data upon success" do
    stub_successful_igdb_api_request(
      @full_pathname,
      @game_json,
      @twitch_bearer_token,
    )
    facade =
      IgdbRequestFacade.new(
        igdb_id: @igdb_id,
        pathname: @pathname,
        twitch_bearer_token: @twitch_bearer_token,
      )
    igdb_data = facade.get_igdb_data[:igdb_data]
    assert_equal(igdb_data, JSON.parse(@game_json).first)
  end

  test "should return an error when the IGDB request fails" do
    stub_igdb_api_request_failure(@full_pathname)
    facade =
      IgdbRequestFacade.new(
        igdb_id: @igdb_id,
        pathname: @pathname,
        twitch_bearer_token: @twitch_bearer_token,
      )
    error = facade.get_igdb_data[:error]
    assert_equal(error.to_json, igdb_api_error.to_json)
  end
end
