require "test_helper"

class Api::InvolvedCompanies::CreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include CompanyCreateTestHelper
  include CompanyLogoCreateTestHelper
  include InvolvedCompanyCreateTestHelper

  setup do
    @game = Game.new(igdb_id: 1026)
    @ids = igdb_game_data["involved_companies"]
  end

  test "should create new involved_companies" do
    stub_successful_company_logo_responses
    stub_successful_company_responses
    stub_successful_involved_company_responses
    assert_difference("InvolvedCompany.count", +@ids.count) do
      facade =
        Api::InvolvedCompanies::CreateFacade.new(
          game: @game,
          ids: @ids,
          twitch_bearer_token: stubbed_twitch_bearer_token,
        )
      facade.find_or_create_involved_companies
    end
  end

  test "should populate involved_company fields" do
    stub_successful_company_logo_responses
    stub_successful_company_responses
    stub_successful_involved_company_responses
    involved_company_id = @ids.first
    facade =
      Api::InvolvedCompanies::CreateFacade.new(
        game: @game,
        ids: @ids,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    facade.find_or_create_involved_companies
    involved_company_json =
      JSON.parse(
        json_mocks("igdb/involved_companies/#{involved_company_id}.json"),
      ).first
    assert_equal(
      involved_company_json["publisher"],
      InvolvedCompany.last.is_publisher,
    )
  end

  test "should not create involved_companies when the igdb request fails" do
    stub_involved_company_request_failures
    assert_difference("InvolvedCompany.count", +0) do
      facade =
        Api::InvolvedCompanies::CreateFacade.new(
          game: @game,
          ids: @ids,
          twitch_bearer_token: stubbed_twitch_bearer_token,
        )
      facade.find_or_create_involved_companies
    end
  end

  test "should not create involved_companies when the igdb request for company fails" do
    stub_company_request_failures
    stub_successful_involved_company_responses
    assert_difference("InvolvedCompany.count", +0) do
      facade =
        Api::InvolvedCompanies::CreateFacade.new(
          game: @game,
          ids: @ids,
          twitch_bearer_token: stubbed_twitch_bearer_token,
        )
      facade.find_or_create_involved_companies
    end
  end

  test "should return successfully found or created involved_companies" do
    stub_successful_company_responses
    stub_successful_company_logo_responses
    stub_successful_involved_company_responses
    facade =
      Api::InvolvedCompanies::CreateFacade.new(
        game: @game,
        ids: @ids,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    igdb_ids =
      facade.find_or_create_involved_companies[:involved_companies].map(
        &:igdb_id
      )
    assert_equal igdb_ids, @ids
  end

  test "should return errors for any failed involved company igdb api requests" do
    stub_involved_company_request_failures
    facade =
      Api::InvolvedCompanies::CreateFacade.new(
        game: @game,
        ids: @ids,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    response = facade.find_or_create_involved_companies
    response[:errors][:involved_companies].each_with_index do |error, index|
      assert_equal(error, { @ids[index] => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed company igdb api requests" do
    stub_company_request_failures
    stub_successful_involved_company_responses
    facade =
      Api::InvolvedCompanies::CreateFacade.new(
        game: @game,
        ids: @ids,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    response = facade.find_or_create_involved_companies
    assert_equal response[:errors][:companies].count, stubbed_company_ids.count
  end

  test "should return errors for any failed company logo igdb api requests" do
    stub_successful_company_responses
    stub_successful_involved_company_responses
    stub_company_logo_request_failures
    facade =
      Api::InvolvedCompanies::CreateFacade.new(
        game: @game,
        ids: @ids,
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    response = facade.find_or_create_involved_companies
    assert_equal(
      response[:errors][:company_logos].count,
      stubbed_company_logo_ids.count,
    )
  end

  test "should return errors for any failed involved_company creations" do
    stub_successful_company_responses
    stub_successful_company_logo_responses
    stub_successful_igdb_api_request(
      "involved_companies/#{nil}",
      json_mocks("igdb/involved_companies/101094.json"),
      stubbed_twitch_bearer_token,
    )
    facade =
      Api::InvolvedCompanies::CreateFacade.new(
        game: @game,
        ids: [nil],
        twitch_bearer_token: stubbed_twitch_bearer_token,
      )
    request = facade.find_or_create_involved_companies
    errors = request[:errors][:involved_companies]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end
end
