require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module PlatformRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_platform_refresh_responses
    igdb_game_data["platforms"].each do |id|
      stub_successful_igdb_api_request(
        "platforms/#{id}",
        json_mocks("igdb/platforms/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_platform_refresh_request_failures
    igdb_game_data["platforms"].each do |id|
      stub_igdb_api_request_failure("platforms/#{id}")
    end
  end

  def stub_platform_refresh_responses(with_platform_failures)
    return stub_platform_refresh_request_failures if with_platform_failures

    stub_successful_platform_refresh_responses
  end
end
