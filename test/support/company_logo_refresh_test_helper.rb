require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module CompanyLogoRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stubbed_company_logo_ids
    [7672, 10_782]
  end

  def stub_successful_company_logo_refresh_responses
    stubbed_company_logo_ids.each do |id|
      stub_successful_igdb_api_request(
        "company_logos/#{id}",
        json_mocks("igdb/company_logos/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_company_logo_refresh_request_failures
    stubbed_company_logo_ids.each do |id|
      stub_igdb_api_request_failure("company_logos/#{id}")
    end
  end

  def stub_company_logo_refresh_responses(with_company_logo_failures)
    if with_company_logo_failures
      return stub_company_logo_refresh_request_failures
    end

    stub_successful_company_logo_refresh_responses
  end
end
