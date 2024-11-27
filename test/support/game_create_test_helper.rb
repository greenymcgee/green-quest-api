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
    with_artwork_failures: false,
    with_cover_failure: false,
    with_game_mode_failures: false,
    with_genre_failures: false,
    with_platform_failures: false,
    with_company_failures: false,
    with_involved_company_failures: false,
    with_release_date_failures: false,
    with_screenshot_failures: false,
    with_website_failures: false
  )
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/#{game_id}",
      game_json,
      stubbed_twitch_bearer_token,
    )
    stub_age_rating_responses(with_age_rating_failures)
    stub_artwork_responses(with_artwork_failures)
    stub_cover_responses(with_cover_failure)
    stub_game_mode_responses(with_game_mode_failures)
    stub_genre_responses(with_genre_failures)
    stub_platform_responses(with_platform_failures)
    stub_involved_company_responses(with_involved_company_failures)
    stub_company_responses(with_company_failures)
    stub_screenshot_responses(with_screenshot_failures)
    stub_release_date_responses(with_release_date_failures)
    stub_website_responses(with_website_failures)
  end

  private

  def stub_artwork_responses(with_artwork_failures)
    return stub_artwork_request_failures if with_artwork_failures

    stub_successful_artwork_responses
  end

  def stub_age_rating_responses(with_age_rating_failures)
    return stub_age_rating_request_failures if with_age_rating_failures

    stub_successful_age_rating_responses
  end

  def stub_cover_responses(with_cover_failure)
    return stub_cover_request_failures if with_cover_failure

    stub_successful_cover_responses
  end

  def stub_game_mode_responses(with_game_mode_failures)
    return stub_game_mode_request_failures if with_game_mode_failures

    stub_successful_game_mode_responses
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

  def stub_release_date_responses(with_release_date_failures)
    return stub_release_date_request_failures if with_release_date_failures

    stub_successful_release_date_responses
  end

  def stub_screenshot_responses(with_screenshot_failures)
    return stub_screenshot_request_failures if with_screenshot_failures

    stub_successful_screenshot_responses
  end

  def stub_website_responses(with_website_failures)
    return stub_website_request_failures if with_website_failures

    stub_successful_website_responses
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

  def stub_successful_artwork_responses
    igdb_game_data["artworks"].each do |id|
      stub_successful_igdb_api_request(
        "artworks/#{id}",
        json_mocks("igdb/artworks/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_artwork_request_failures
    igdb_game_data["artworks"].each do |id|
      stub_igdb_api_request_failure("artworks/#{id}")
    end
  end

  def stub_successful_cover_responses
    stub_successful_igdb_api_request(
      "covers/#{igdb_game_data["cover"]}",
      json_mocks("igdb/covers/#{igdb_game_data["cover"]}.json"),
      stubbed_twitch_bearer_token,
    )
  end

  def stub_cover_request_failures
    stub_igdb_api_request_failure("covers/#{igdb_game_data["cover"]}")
  end

  def stub_game_mode_request_failures
    igdb_game_data["game_modes"].each do |id|
      stub_igdb_api_request_failure("game_modes/#{id}")
    end
  end

  def stub_successful_game_mode_responses
    igdb_game_data["game_modes"].each do |id|
      stub_successful_igdb_api_request(
        "game_modes/#{id}",
        json_mocks("igdb/game_modes/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
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

  def stub_successful_release_date_responses
    igdb_game_data["release_dates"].each do |id|
      stub_successful_igdb_api_request(
        "release_dates/#{id}",
        json_mocks("igdb/release_dates/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_release_date_request_failures
    igdb_game_data["release_dates"].each do |id|
      stub_igdb_api_request_failure("release_dates/#{id}")
    end
  end

  def stub_successful_screenshot_responses
    igdb_game_data["screenshots"].each do |id|
      stub_successful_igdb_api_request(
        "screenshots/#{id}",
        json_mocks("igdb/screenshots/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_screenshot_request_failures
    igdb_game_data["screenshots"].each do |id|
      stub_igdb_api_request_failure("screenshots/#{id}")
    end
  end

  def stub_successful_website_responses
    igdb_game_data["websites"].each do |id|
      stub_successful_igdb_api_request(
        "websites/#{id}",
        json_mocks("igdb/websites/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_website_request_failures
    igdb_game_data["websites"].each do |id|
      stub_igdb_api_request_failure("websites/#{id}")
    end
  end
end
