require "./test/support/artwork_refresh_test_helper.rb"
require "./test/support/company_refresh_test_helper.rb"
require "./test/support/company_logo_refresh_test_helper.rb"
require "./test/support/game_engine_refresh_test_helper.rb"
require "./test/support/game_engine_logo_refresh_test_helper.rb"
require "./test/support/involved_company_refresh_test_helper.rb"
require "./test/support/platform_refresh_test_helper.rb"
require "./test/support/platform_logo_refresh_test_helper.rb"

module GameRefreshTestHelper
  include ArtworkRefreshTestHelper
  include CompanyRefreshTestHelper
  include CompanyLogoRefreshTestHelper
  include InvolvedCompanyRefreshTestHelper
  include GameEngineRefreshTestHelper
  include GameEngineLogoRefreshTestHelper
  include PlatformRefreshTestHelper
  include PlatformLogoRefreshTestHelper

  def stub_successful_game_refresh_request(
    game_id,
    with_artwork_failures: false,
    with_company_failures: false,
    with_company_logo_failures: false,
    with_involved_company_failures: false,
    with_game_engine_failures: false,
    with_game_engine_logo_failures: false,
    with_platform_failures: false,
    with_platform_logo_failures: false
  )
    stub_successful_twitch_oauth_request
    stub_successful_igdb_api_request(
      "games/#{game_id}",
      game_json,
      stubbed_twitch_bearer_token,
    )
    stub_artwork_refresh_responses(with_artwork_failures)
    stub_company_refresh_responses(with_company_failures)
    stub_company_logo_refresh_responses(with_company_logo_failures)
    stub_game_engine_refresh_responses(with_game_engine_failures)
    stub_game_engine_logo_refresh_responses(with_game_engine_logo_failures)
    stub_involved_company_refresh_responses(with_involved_company_failures)
    stub_platform_refresh_responses(with_platform_failures)
    stub_platform_logo_refresh_responses(with_platform_logo_failures)
  end
end
