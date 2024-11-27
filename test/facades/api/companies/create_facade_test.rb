require "test_helper"

class Api::Companies::CreateFacadeTest < ActionDispatch::IntegrationTest
  include TwitchOauthTestHelper
  include IgdbApiTestHelper
  include CompanyCreateTestHelper

  setup do
    @twitch_oauth_token = stubbed_twitch_bearer_token
    @id = stubbed_company_ids.first
  end

  test "should create a new company" do
    stub_successful_company_responses
    assert_difference("Company.count", +1) do
      facade = Api::Companies::CreateFacade.new(@id, @twitch_oauth_token)
      facade.find_or_create_company
    end
  end

  test "should not create a company when the igdb request fails" do
    stub_company_request_failures
    assert_difference("Company.count", +0) do
      facade = Api::Companies::CreateFacade.new(@id, @twitch_oauth_token)
      facade.find_or_create_company
    end
  end

  test "should return a successfully found or created company" do
    stub_successful_company_responses
    facade = Api::Companies::CreateFacade.new(@id, @twitch_oauth_token)
    igdb_id = facade.find_or_create_company[:company].igdb_id
    assert_equal igdb_id, @id
  end

  test "should return errors for any failed igdb api requests" do
    stub_company_request_failures
    facade = Api::Companies::CreateFacade.new(@id, @twitch_oauth_token)
    response = facade.find_or_create_company
    response[:errors].each_with_index do |error, index|
      assert_equal(error, { @id => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed company creations" do
    stub_successful_igdb_api_request(
      "companies/#{nil}",
      json_mocks("igdb/companies/70.json"),
      @twitch_oauth_token,
    )
    facade = Api::Companies::CreateFacade.new(nil, @twitch_oauth_token)
    request = facade.find_or_create_company
    errors = request[:errors]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end
end
