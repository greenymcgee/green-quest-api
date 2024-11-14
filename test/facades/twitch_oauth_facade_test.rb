require "test_helper"

class TwitchOauthFacadeTest < ActionDispatch::IntegrationTest
  include TwitchOauthTestHelper

  test "should return a bearer token upon success" do
    stub_successful_twitch_oauth_request
    result = TwitchOauthFacade.get_twitch_oauth_token
    assert_equal(
      result,
      { bearer_token: "Bearer #{twitch_oauth_access_token}" },
    )
  end

  test "should return a bad request error" do
    stub_twitch_oauth_request_failure
    error = TwitchOauthFacade.get_twitch_oauth_token[:error]
    assert_equal(error.to_json, twitch_oauth_error.to_json)
  end
end
