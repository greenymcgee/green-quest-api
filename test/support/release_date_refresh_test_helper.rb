require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module ReleaseDateRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_release_date_refresh_responses
    igdb_game_data["release_dates"].each do |id|
      stub_successful_igdb_api_request(
        "release_dates/#{id}",
        json_mocks("igdb/release_dates/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_release_date_refresh_request_failures
    igdb_game_data["release_dates"].each do |id|
      stub_igdb_api_request_failure("release_dates/#{id}")
    end
  end

  def stub_release_date_refresh_responses(with_release_date_failures)
    if with_release_date_failures
      return stub_release_date_refresh_request_failures
    end

    stub_successful_release_date_refresh_responses
  end
end
