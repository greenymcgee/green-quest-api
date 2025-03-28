require "./test/support/age_rating_create_test_helper.rb"
require "./test/support/artwork_create_test_helper.rb"
require "./test/support/company_create_test_helper.rb"
require "./test/support/company_logo_create_test_helper.rb"
require "./test/support/cover_create_test_helper.rb"
require "./test/support/franchise_create_test_helper.rb"
require "./test/support/game_engine_create_test_helper.rb"
require "./test/support/game_engine_logo_create_test_helper.rb"
require "./test/support/game_video_create_test_helper.rb"
require "./test/support/genre_create_test_helper.rb"
require "./test/support/igdb_api_test_helper.rb"
require "./test/support/involved_company_create_test_helper.rb"
require "./test/support/platform_create_test_helper.rb"
require "./test/support/platform_logo_create_test_helper.rb"
require "./test/support/player_perspective_create_test_helper.rb"
require "./test/support/theme_create_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module GameCreateTestHelper
  include AgeRatingCreateTestHelper
  include ArtworkCreateTestHelper
  include CoverCreateTestHelper
  include CompanyCreateTestHelper
  include CompanyLogoCreateTestHelper
  include FranchiseCreateTestHelper
  include GameEngineCreateTestHelper
  include GameEngineLogoCreateTestHelper
  include GameVideoCreateTestHelper
  include GenreCreateTestHelper
  include IgdbApiTestHelper
  include InvolvedCompanyCreateTestHelper
  include PlatformCreateTestHelper
  include PlatformLogoCreateTestHelper
  include PlayerPerspectiveCreateTestHelper
  include ThemeCreateTestHelper
  include TwitchOauthTestHelper

  def stub_successful_game_create_request(
    game_id,
    with_age_rating_failures: false,
    with_artwork_failures: false,
    with_company_failures: false,
    with_company_logo_failures: false,
    with_cover_failure: false,
    with_franchise_failures: false,
    with_game_mode_failures: false,
    with_game_engine_failures: false,
    with_game_engine_logo_failures: false,
    with_game_video_failures: false,
    with_genre_failures: false,
    with_platform_failures: false,
    with_platform_logo_failures: false,
    with_player_perspective_failures: false,
    with_involved_company_failures: false,
    with_release_date_failures: false,
    with_screenshot_failures: false,
    with_theme_failures: false,
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
    stub_company_responses(with_company_failures)
    stub_company_logo_responses(with_company_logo_failures)
    stub_cover_response(with_cover_failure)
    stub_franchise_responses(with_franchise_failures)
    stub_game_engine_responses(with_game_engine_failures)
    stub_game_engine_logo_responses(with_game_engine_logo_failures)
    stub_game_mode_responses(with_game_mode_failures)
    stub_game_video_responses(with_game_video_failures)
    stub_genre_responses(with_genre_failures)
    stub_platform_responses(with_platform_failures)
    stub_platform_logo_responses(with_platform_logo_failures)
    stub_player_perspective_responses(with_player_perspective_failures)
    stub_involved_company_responses(with_involved_company_failures)
    stub_release_date_responses(with_release_date_failures)
    stub_screenshot_responses(with_screenshot_failures)
    stub_theme_responses(with_theme_failures)
    stub_website_responses(with_website_failures)
  end

  private

  def stub_game_mode_responses(with_game_mode_failures)
    return stub_game_mode_request_failures if with_game_mode_failures

    stub_successful_game_mode_responses
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
