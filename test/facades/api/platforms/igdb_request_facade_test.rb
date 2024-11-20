require "test_helper"

class Api::Platforms::RequestFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @platform_id = 2
    @pathname = "platforms/#{@platform_id}"
    @platform_json = json_mocks("igdb/platforms/5.json")
  end

  test "should return platform data upon success" do
    stub_successful_igdb_api_request(
      @pathname,
      @platform_json,
      @twitch_oauth_token,
    )
    facade =
      Api::Platforms::IgdbRequestFacade.new(@platform_id, @twitch_oauth_token)
    platform = facade.get_igdb_platform_data[:igdb_platform_data]
    assert_equal(platform, JSON.parse(@platform_json).first)
  end

  test "should return an error when the platform request fails" do
    stub_igdb_api_request_failure(@pathname)
    facade =
      Api::Platforms::IgdbRequestFacade.new(@platform_id, @twitch_oauth_token)
    error = facade.get_igdb_platform_data[:error]
    assert_equal(error.to_json, igdb_api_error.to_json)
  end
end
