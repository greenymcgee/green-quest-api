require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module FranchiseRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_franchise_refresh_responses
    igdb_game_data["franchises"].each do |id|
      stub_successful_igdb_api_request(
        "franchises/#{id}",
        json_mocks("igdb/franchises/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_franchise_refresh_request_failures
    igdb_game_data["franchises"].each do |id|
      stub_igdb_api_request_failure("franchises/#{id}")
    end
  end

  def stub_franchise_refresh_responses(with_franchise_failures)
    return stub_franchise_refresh_request_failures if with_franchise_failures

    stub_successful_franchise_refresh_responses
  end
end
