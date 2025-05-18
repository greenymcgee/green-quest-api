require "./test/support/age_rating_refresh_test_helper.rb"
require "./test/support/artwork_refresh_test_helper.rb"
require "./test/support/company_refresh_test_helper.rb"
require "./test/support/company_logo_refresh_test_helper.rb"
require "./test/support/cover_refresh_test_helper.rb"
require "./test/support/franchise_refresh_test_helper.rb"
require "./test/support/game_engine_refresh_test_helper.rb"
require "./test/support/game_engine_logo_refresh_test_helper.rb"
require "./test/support/game_mode_refresh_test_helper.rb"
require "./test/support/game_video_refresh_test_helper.rb"
require "./test/support/genre_refresh_test_helper.rb"
require "./test/support/involved_company_refresh_test_helper.rb"
require "./test/support/platform_refresh_test_helper.rb"
require "./test/support/platform_logo_refresh_test_helper.rb"

module GameRefreshTestHelper
  include AgeRatingRefreshTestHelper
  include ArtworkRefreshTestHelper
  include CompanyRefreshTestHelper
  include CompanyLogoRefreshTestHelper
  include CoverRefreshTestHelper
  include FranchiseRefreshTestHelper
  include InvolvedCompanyRefreshTestHelper
  include GameEngineRefreshTestHelper
  include GameEngineLogoRefreshTestHelper
  include GameModeRefreshTestHelper
  include GameVideoRefreshTestHelper
  include GenreRefreshTestHelper
  include PlatformRefreshTestHelper
  include PlatformLogoRefreshTestHelper

  def stub_successful_game_refresh_request(
    game_id,
    with_age_rating_failures: false,
    with_artwork_failures: false,
    with_company_failures: false,
    with_company_logo_failures: false,
    with_cover_failures: false,
    with_franchise_failures: false,
    with_involved_company_failures: false,
    with_game_engine_failures: false,
    with_game_engine_logo_failures: false,
    with_game_mode_failures: false,
    with_game_video_failures: false,
    with_genre_failures: false,
    with_platform_failures: false,
    with_platform_logo_failures: false
  )
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/#{game_id}",
      game_json,
      stubbed_twitch_bearer_token,
    )
    stub_age_rating_refresh_responses(with_age_rating_failures)
    stub_artwork_refresh_responses(with_artwork_failures)
    stub_company_refresh_responses(with_company_failures)
    stub_company_logo_refresh_responses(with_company_logo_failures)
    stub_cover_refresh_response(with_cover_failures)
    stub_franchise_refresh_responses(with_franchise_failures)
    stub_game_engine_refresh_responses(with_game_engine_failures)
    stub_game_engine_logo_refresh_responses(with_game_engine_logo_failures)
    stub_game_mode_refresh_responses(with_game_mode_failures)
    stub_game_video_refresh_responses(with_game_video_failures)
    stub_genre_refresh_responses(with_genre_failures)
    stub_involved_company_refresh_responses(with_involved_company_failures)
    stub_platform_refresh_responses(with_platform_failures)
    stub_platform_logo_refresh_responses(with_platform_logo_failures)
  end
end
