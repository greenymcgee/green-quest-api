require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module GameVideoCreateTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_game_video_responses
    igdb_game_data["videos"].each do |id|
      stub_successful_igdb_api_request(
        "game_videos/#{id}",
        json_mocks("igdb/game_videos/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_game_video_request_failures
    igdb_game_data["videos"].each do |id|
      stub_igdb_api_request_failure("game_videos/#{id}")
    end
  end

  def stub_game_video_responses(with_game_video_failures)
    return stub_game_video_request_failures if with_game_video_failures

    stub_successful_game_video_responses
  end
end
