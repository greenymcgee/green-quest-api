require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module ThemeRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_theme_refresh_responses
    igdb_game_data["themes"].each do |id|
      stub_successful_igdb_api_request(
        "themes/#{id}",
        json_mocks("igdb/themes/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_theme_refresh_request_failures
    igdb_game_data["themes"].each do |id|
      stub_igdb_api_request_failure("themes/#{id}")
    end
  end

  def stub_theme_refresh_responses(with_theme_failures)
    return stub_theme_refresh_request_failures if with_theme_failures

    stub_successful_theme_refresh_responses
  end
end
