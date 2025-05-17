require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module GameEngineRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_game_engine_refresh_responses
    igdb_game_data["game_engines"].each do |id|
      stub_successful_igdb_api_request(
        "game_engines/#{id}",
        json_mocks("igdb/game_engines/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_game_engine_refresh_request_failures
    igdb_game_data["game_engines"].each do |id|
      stub_igdb_api_request_failure("game_engines/#{id}")
    end
  end

  def stub_game_engine_refresh_responses(with_game_engine_failures)
    if with_game_engine_failures
      return stub_game_engine_refresh_request_failures
    end

    stub_successful_game_engine_refresh_responses
  end
end
