require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module WebsiteRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_website_refresh_responses
    igdb_game_data["websites"].each do |id|
      stub_successful_igdb_api_request(
        "websites/#{id}",
        json_mocks("igdb/websites/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_website_refresh_request_failures
    igdb_game_data["websites"].each do |id|
      stub_igdb_api_request_failure("websites/#{id}")
    end
  end

  def stub_website_refresh_responses(with_website_failures)
    return stub_website_refresh_request_failures if with_website_failures

    stub_successful_website_refresh_responses
  end
end
