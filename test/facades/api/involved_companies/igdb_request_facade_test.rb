require "test_helper"

class Api::InvolvedCompanies::RequestFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @involved_company_id = 2
    @pathname = "involved_companies/#{@involved_company_id}"
    @involved_company_json = json_mocks("igdb/involved_companies/101094.json")
  end

  test "should return involved company data upon success" do
    stub_successful_igdb_api_request(
      @pathname,
      @involved_company_json,
      @twitch_oauth_token,
    )
    facade =
      Api::InvolvedCompanies::IgdbRequestFacade.new(
        @involved_company_id,
        @twitch_oauth_token,
      )
    involved_company =
      facade.get_igdb_involved_company_data[:igdb_involved_company_data]
    assert_equal(involved_company, JSON.parse(@involved_company_json).first)
  end

  test "should return an error when the involved company request fails" do
    stub_igdb_api_request_failure(@pathname)
    facade =
      Api::InvolvedCompanies::IgdbRequestFacade.new(
        @involved_company_id,
        @twitch_oauth_token,
      )
    error = facade.get_igdb_involved_company_data[:error]
    assert_equal(error.to_json, igdb_api_error.to_json)
  end
end
