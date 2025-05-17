require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module ArtworkRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_artwork_refresh_responses
    igdb_game_data["artworks"].each do |id|
      stub_successful_igdb_api_request(
        "artworks/#{id}",
        json_mocks("igdb/artworks/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_artwork_refresh_request_failures
    igdb_game_data["artworks"].each do |id|
      stub_igdb_api_request_failure("artworks/#{id}")
    end
  end

  def stub_artwork_refresh_responses(with_artwork_failures)
    return stub_artwork_refresh_request_failures if with_artwork_failures

    stub_successful_artwork_refresh_responses
  end
end
