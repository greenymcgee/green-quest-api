require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module CoverRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_cover_refresh_response
    stub_successful_igdb_api_request(
      "covers/#{igdb_game_data["cover"]}",
      json_mocks("igdb/covers/#{igdb_game_data["cover"]}.refresh.json"),
      stubbed_twitch_bearer_token,
    )
  end

  def stub_cover_refresh_request_failure
    stub_igdb_api_request_failure("covers/#{igdb_game_data["cover"]}")
  end

  def stub_cover_refresh_response(with_cover_failure)
    return stub_cover_refresh_request_failure if with_cover_failure

    stub_successful_cover_refresh_response
  end
end
