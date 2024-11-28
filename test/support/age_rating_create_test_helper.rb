require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module AgeRatingCreateTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_age_rating_responses
    igdb_game_data["age_ratings"].each do |id|
      stub_successful_igdb_api_request(
        "age_ratings/#{id}",
        json_mocks("igdb/age_ratings/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_age_rating_request_failures
    igdb_game_data["age_ratings"].each do |id|
      stub_igdb_api_request_failure("age_ratings/#{id}")
    end
  end

  def stub_age_rating_responses(with_age_rating_failures)
    return stub_age_rating_request_failures if with_age_rating_failures

    stub_successful_age_rating_responses
  end
end
