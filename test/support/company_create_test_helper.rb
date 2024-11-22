require "./test/support/igdb_api_test_helper.rb"

module CompanyCreateTestHelper
  include IgdbApiTestHelper

  def stubbed_company_ids
    [70, 421, 812, 25_230, 32_350, 33_804]
  end

  def stub_successful_company_requests(twitch_oauth_token)
    stubbed_company_ids.each do |id|
      stub_successful_igdb_api_request(
        "companies/#{id}",
        json_mocks("igdb/companies/#{id}.json"),
        twitch_oauth_token,
      )
    end
  end

  def stub_company_request_failures
    stubbed_company_ids.each do |id|
      stub_igdb_api_request_failure("companies/#{id}")
    end
  end
end
