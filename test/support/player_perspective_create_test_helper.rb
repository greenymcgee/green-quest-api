require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module PlayerPerspectiveCreateTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_player_perspective_responses
    igdb_game_data["player_perspectives"].each do |id|
      stub_successful_igdb_api_request(
        "player_perspectives/#{id}",
        json_mocks("igdb/player_perspectives/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_player_perspective_request_failures
    igdb_game_data["player_perspectives"].each do |id|
      stub_igdb_api_request_failure("player_perspectives/#{id}")
    end
  end

  def stub_player_perspective_responses(with_player_perspective_failures)
    if with_player_perspective_failures
      return stub_player_perspective_request_failures
    end

    stub_successful_player_perspective_responses
  end
end
