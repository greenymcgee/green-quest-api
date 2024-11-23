require "./test/support/igdb_api_test_helper.rb"

module InvolvedCompanyCreateTestHelper
  include IgdbApiTestHelper

  def stub_successful_involved_company_requests(ids, twitch_bearer_token)
    ids.each do |id|
      stub_successful_igdb_api_request(
        "involved_companies/#{id}",
        json_mocks("igdb/involved_companies/#{id}.json"),
        twitch_bearer_token,
      )
    end
  end

  def stub_involved_company_request_failures(ids)
    ids.each { |id| stub_igdb_api_request_failure("involved_companies/#{id}") }
  end
end
