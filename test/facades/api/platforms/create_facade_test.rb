require "test_helper"

class Api::Platforms::CreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include PlatformCreateTestHelper
  include PlatformLogoCreateTestHelper

  setup do
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @ids = igdb_game_data["platforms"]
  end

  test "should create new platforms" do
    stub_successful_platform_responses
    stub_successful_platform_logo_responses
    assert_difference("Platform.count", +@ids.count) do
      facade = Api::Platforms::CreateFacade.new(@ids, @twitch_bearer_token)
      facade.find_or_create_platforms
    end
  end

  test "should populate platform fields" do
    stub_successful_platform_responses
    stub_successful_platform_logo_responses
    platform_id = @ids.first
    facade =
      Api::Platforms::CreateFacade.new([platform_id], @twitch_bearer_token)
    facade.find_or_create_platforms
    platform_json =
      JSON.parse(json_mocks("igdb/platforms/#{platform_id}.json")).first
    assert_equal platform_json["name"], Platform.last.name
  end

  test "should not create platforms when the igdb request fails" do
    stub_platform_request_failures
    assert_difference("Platform.count", +0) do
      facade = Api::Platforms::CreateFacade.new(@ids, @twitch_bearer_token)
      facade.find_or_create_platforms
    end
  end

  test "should return successfully found or created platforms" do
    stub_successful_platform_responses
    stub_successful_platform_logo_responses
    facade = Api::Platforms::CreateFacade.new(@ids, @twitch_bearer_token)
    igdb_ids = facade.find_or_create_platforms[:platforms].map(&:igdb_id)
    assert_equal igdb_ids, @ids
  end

  test "should return errors for any failed platform igdb api requests" do
    stub_platform_request_failures
    facade = Api::Platforms::CreateFacade.new(@ids, @twitch_bearer_token)
    response = facade.find_or_create_platforms
    response[:errors][:platforms].each_with_index do |error, index|
      assert_equal(error, { @ids[index] => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed platform creations" do
    stub_successful_platform_logo_responses
    stub_successful_igdb_api_request(
      "platforms/#{nil}",
      json_mocks("igdb/platforms/19.json"),
      stubbed_twitch_bearer_token,
    )
    facade = Api::Platforms::CreateFacade.new([nil], @twitch_bearer_token)
    request = facade.find_or_create_platforms
    errors = request[:errors][:platforms]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end

  test "should return errors for any failed platform_logo igdb api requests" do
    stub_platform_logo_request_failures
    stub_successful_platform_responses
    facade = Api::Platforms::CreateFacade.new(@ids, @twitch_bearer_token)
    response = facade.find_or_create_platforms
    assert_equal(
      response[:errors][:platform_logos].count,
      stubbed_platform_logo_ids.count,
    )
  end

  test "should not attempt to create when the igdb_data is blank" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "platforms/#{id}",
        [].to_json,
        @twitch_bearer_token,
      )
    end
    assert_difference("Platform.count", +0) do
      Api::Platforms::CreateFacade.new(
        @ids,
        @twitch_bearer_token,
      ).find_or_create_platforms
    end
  end
end
