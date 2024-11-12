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
    result = TwitchOauthFacade.get_twitch_oauth_token[:error].message
    expectation = StandardError.new({ message: "Bad request" }.to_json).message
    assert_equal(result, expectation)
  end

  test "should return an unauthorized request error" do
    stub_twitch_oauth_request_failure(401, "Unauthorized")
    result = TwitchOauthFacade.get_twitch_oauth_token[:error].message
    expectation = StandardError.new({ message: "Unauthorized" }.to_json).message
    assert_equal(result, expectation)
  end
end
