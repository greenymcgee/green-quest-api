require "test_helper"

class Api::Companies::RequestFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @company_id = 70
    @pathname = "companies/#{@company_id}"
    @company_json = json_mocks("igdb/companies/70.json")
  end

  test "should return company data upon success" do
    stub_successful_igdb_api_request(
      @pathname,
      @company_json,
      @twitch_oauth_token,
    )
    facade =
      Api::Companies::IgdbRequestFacade.new(@company_id, @twitch_oauth_token)
    company = facade.get_igdb_company_data[:igdb_company_data]
    assert_equal(company, JSON.parse(@company_json).first)
  end

  test "should return an error when the company request fails" do
    stub_igdb_api_request_failure(@pathname)
    facade =
      Api::Companies::IgdbRequestFacade.new(@company_id, @twitch_oauth_token)
    error = facade.get_igdb_company_data[:error]
    assert_equal(error.to_json, igdb_api_error.to_json)
  end
end
