require "test_helper"

class Api::Companies::CreateFacadeTest < ActionDispatch::IntegrationTest
  include TwitchOauthTestHelper
  include IgdbApiTestHelper
  include CompanyCreateTestHelper
  include CompanyLogoCreateTestHelper

  setup do
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @id = stubbed_company_ids.first
  end

  test "should create a new company" do
    stub_successful_company_responses
    stub_successful_company_logo_responses
    assert_difference("Company.count", +1) do
      facade = Api::Companies::CreateFacade.new(@id, @twitch_bearer_token)
      facade.find_or_create_company
    end
  end

  test "should populate company fields" do
    stub_successful_company_responses
    stub_successful_company_logo_responses
    facade = Api::Companies::CreateFacade.new(@id, @twitch_bearer_token)
    facade.find_or_create_company
    company_json = json_mocks("igdb/companies/#{@id}.json")
    company_data = JSON.parse(company_json).first
    assert_equal company_data["name"], Company.last.name
  end

  test "should not create a company when the igdb request fails" do
    stub_company_request_failures
    assert_difference("Company.count", +0) do
      facade = Api::Companies::CreateFacade.new(@id, @twitch_bearer_token)
      facade.find_or_create_company
    end
  end

  test "should return a successfully found or created company" do
    stub_successful_company_responses
    facade = Api::Companies::CreateFacade.new(@id, @twitch_bearer_token)
    igdb_id = facade.find_or_create_company[:company].igdb_id
    assert_equal igdb_id, @id
  end

  test "should return errors for any failed company igdb api requests" do
    stub_company_request_failures
    facade = Api::Companies::CreateFacade.new(@id, @twitch_bearer_token)
    response = facade.find_or_create_company
    response[:errors][:companies].each_with_index do |error, index|
      assert_equal(error, { @id => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed company creations" do
    stub_successful_company_logo_responses
    stub_successful_igdb_api_request(
      "companies/#{nil}",
      json_mocks("igdb/companies/70.json"),
      @twitch_bearer_token,
    )
    facade = Api::Companies::CreateFacade.new(nil, @twitch_bearer_token)
    request = facade.find_or_create_company
    errors = request[:errors][:companies]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end

  test "should return errors for any failed company_logo igdb api requests" do
    stub_company_logo_request_failures
    stub_successful_company_responses
    _, id = stubbed_company_ids
    facade = Api::Companies::CreateFacade.new(id, @twitch_bearer_token)
    response = facade.find_or_create_company
    assert_equal(1, response[:errors][:company_logos].count)
  end

  test "should not attempt to create when the igdb_data is blank" do
    stub_successful_igdb_api_request(
      "companies/#{@id}",
      [].to_json,
      @twitch_bearer_token,
    )
    assert_difference("Company.count", +0) do
      Api::Companies::CreateFacade.new(
        @id,
        @twitch_bearer_token,
      ).find_or_create_company
    end
  end
end
