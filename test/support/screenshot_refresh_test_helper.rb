require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module ScreenshotRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_screenshot_refresh_responses
    igdb_game_data["screenshots"].each do |id|
      stub_successful_igdb_api_request(
        "screenshots/#{id}",
        json_mocks("igdb/screenshots/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_screenshot_refresh_request_failures
    igdb_game_data["screenshots"].each do |id|
      stub_igdb_api_request_failure("screenshots/#{id}")
    end
  end

  def stub_screenshot_refresh_responses(with_screenshot_failures)
    return stub_screenshot_refresh_request_failures if with_screenshot_failures

    stub_successful_screenshot_refresh_responses
  end
end
