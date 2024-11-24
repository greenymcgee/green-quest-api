require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"
require "./test/support/company_create_test_helper.rb"
require "./test/support/involved_company_create_test_helper.rb"

module GameCreateTestHelper
  include TwitchOauthTestHelper
  include IgdbApiTestHelper
  include CompanyCreateTestHelper
  include InvolvedCompanyCreateTestHelper

  def stub_successful_game_create_request(
    game_id,
    with_age_rating_failures: false,
    with_genre_failures: false,
    with_platform_failures: false,
    with_company_failures: false,
    with_involved_company_failures: false
  )
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/#{game_id}",
      game_json,
      stubbed_twitch_bearer_token,
    )
    stub_age_rating_responses(with_age_rating_failures)
    stub_genre_responses(with_genre_failures)
    stub_platform_responses(with_platform_failures)
    stub_involved_company_responses(with_involved_company_failures)
    stub_company_responses(with_company_failures)
  end

  def stubbed_twitch_bearer_token
    "Bearer #{twitch_oauth_access_token}"
  end

  private

  def stub_age_rating_responses(with_age_rating_failures)
    return stub_age_rating_request_failures if with_age_rating_failures

    stub_successful_age_rating_responses
  end

  def stub_genre_responses(with_genre_failures)
    return stub_genre_request_failures if with_genre_failures

    stub_successful_genre_responses
  end

  def stub_platform_responses(with_platform_failures)
    return stub_platform_request_failures if with_platform_failures

    stub_successful_platform_responses
  end

  def stub_involved_company_responses(with_involved_company_failures)
    if with_involved_company_failures
      return stub_involved_company_request_failures
    end

    stub_successful_involved_company_responses
  end

  def stub_company_responses(with_company_failures)
    return stub_company_request_failures if with_company_failures

    stub_successful_company_responses
  end

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
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_platform_request_failures
    igdb_game_data["platforms"].each do |id|
      stub_igdb_api_request_failure("platforms/#{id}")
    end
  end

  def stub_successful_platform_responses
    igdb_game_data["platforms"].each do |id|
      stub_successful_igdb_api_request(
        "platforms/#{id}",
        json_mocks("igdb/platforms/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_involved_company_request_failures
    igdb_game_data["involved_companies"].each do |id|
      stub_igdb_api_request_failure("involved_companies/#{id}")
    end
  end

  def stub_successful_involved_company_responses
    igdb_game_data["involved_companies"].each do |id|
      stub_successful_igdb_api_request(
        "involved_companies/#{id}",
        json_mocks("igdb/involved_companies/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_company_request_failures
    stubbed_company_ids.each do |id|
      stub_igdb_api_request_failure("companies/#{id}")
    end
  end

  def stub_successful_company_responses
    stubbed_company_ids.each do |id|
      stub_successful_igdb_api_request(
        "companies/#{id}",
        json_mocks("igdb/companies/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def game_json
    json_mocks("igdb/game.json")
  end

  def igdb_game_data
    JSON.parse(game_json).first
  end
end
