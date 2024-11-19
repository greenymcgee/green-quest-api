require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module GameCreateTestHelper
  include TwitchOauthTestHelper
  include IgdbApiTestHelper

  def stub_successful_game_create_request(game_id, with_genre_failures: false)
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/#{game_id}",
      game_json,
      twitch_bearer_token,
    )
    stub_genre_responses(with_genre_failures)
  end

  private

  def stub_genre_responses(with_genre_failures)
    return stub_genre_request_failures if with_genre_failures

    stub_successful_genre_responses
  end

  def stub_genre_request_failures
    igdb_game_data["genres"].each do |genre_id|
      stub_igdb_api_request_failure("genres/#{genre_id}")
    end
  end

  def stub_successful_genre_responses
    igdb_game_data["genres"].each do |genre_id|
      stub_successful_igdb_api_request(
        "genres/#{genre_id}",
        json_mocks("igdb/genres/#{genre_id}.json"),
        twitch_bearer_token,
      )
    end
  end

  def game_json
    json_mocks("igdb/game.json")
  end

  def igdb_game_data
    JSON.parse(game_json).first
  end

  def twitch_bearer_token
    "Bearer #{twitch_oauth_access_token}"
  end
end
