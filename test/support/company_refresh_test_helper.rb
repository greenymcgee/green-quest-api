require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module CompanyRefreshTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stubbed_company_ids
    [25_230, 421, 70]
  end

  def stub_successful_company_refresh_responses
    stubbed_company_ids.each do |id|
      stub_successful_igdb_api_request(
        "companies/#{id}",
        json_mocks("igdb/companies/#{id}.refresh.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_company_refresh_request_failures
    stubbed_company_ids.each do |id|
      stub_igdb_api_request_failure("companies/#{id}")
    end
  end

  def stub_company_refresh_responses(with_company_failures)
    return stub_company_refresh_request_failures if with_company_failures

    stub_successful_company_refresh_responses
  end
end
