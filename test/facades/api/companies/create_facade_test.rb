require "test_helper"

class Api::Companies::CreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include CompanyCreateTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @ids = stubbed_company_ids
  end

  test "should create new companies" do
    stub_successful_company_requests(@twitch_oauth_token)
    assert_difference("Company.count", +@ids.count) do
      facade = Api::Companies::CreateFacade.new(@ids, @twitch_oauth_token)
      facade.find_or_create_companies
    end
  end

  test "should not create companies when the igdb request fails" do
    stub_company_request_failures
    assert_difference("Company.count", +0) do
      facade = Api::Companies::CreateFacade.new(@ids, @twitch_oauth_token)
      facade.find_or_create_companies
    end
  end

  test "should return successfully found or created companies" do
    stub_successful_company_requests(@twitch_oauth_token)
    facade = Api::Companies::CreateFacade.new(@ids, @twitch_oauth_token)
    igdb_ids = facade.find_or_create_companies[:companies].map(&:igdb_id)
    assert_equal igdb_ids, @ids
  end

  test "should return errors for any failed igdb api requests" do
    stub_company_request_failures
    facade = Api::Companies::CreateFacade.new(@ids, @twitch_oauth_token)
    response = facade.find_or_create_companies
    response[:errors].each_with_index do |error, index|
      assert_equal(error, { @ids[index] => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed company creations" do
    stub_successful_igdb_api_request(
      "companies/#{nil}",
      json_mocks("igdb/companies/70.json"),
      @twitch_oauth_token,
    )
    facade = Api::Companies::CreateFacade.new([nil], @twitch_oauth_token)
    request = facade.find_or_create_companies
    errors = request[:errors]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end
end
