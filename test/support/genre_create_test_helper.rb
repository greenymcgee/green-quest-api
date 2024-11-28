require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module GenreCreateTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_genre_responses
    igdb_game_data["genres"].each do |id|
      stub_successful_igdb_api_request(
        "genres/#{id}",
        json_mocks("igdb/genres/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_genre_request_failures
    igdb_game_data["genres"].each do |id|
      stub_igdb_api_request_failure("genres/#{id}")
    end
  end

  def stub_genre_responses(with_genre_failures)
    return stub_genre_request_failures if with_genre_failures

    stub_successful_genre_responses
  end
end
