require "./test/support/igdb_api_test_helper.rb"
require "./test/support/twitch_oauth_test_helper.rb"

module InvolvedCompanyCreateTestHelper
  include IgdbApiTestHelper
  include TwitchOauthTestHelper

  def stub_successful_involved_company_responses
    igdb_game_data["involved_companies"].each do |id|
      stub_successful_igdb_api_request(
        "involved_companies/#{id}",
        json_mocks("igdb/involved_companies/#{id}.json"),
        stubbed_twitch_bearer_token,
      )
    end
  end

  def stub_involved_company_request_failures
    igdb_game_data["involved_companies"].each do |id|
      stub_igdb_api_request_failure("involved_companies/#{id}")
    end
  end

  def stub_involved_company_responses(with_involved_company_failures)
    if with_involved_company_failures
      return stub_involved_company_request_failures
    end

    stub_successful_involved_company_responses
  end
end
