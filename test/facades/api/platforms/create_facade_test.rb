require "test_helper"

class Api::Platforms::CreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper
  include PlatformCreateTestHelper
  include PlatformLogoCreateTestHelper

  setup do
    @twitch_oauth_token = stubbed_twitch_bearer_token
    @ids = JSON.parse(json_mocks("igdb/game.json")).first["platforms"]
  end

  test "should create new platforms" do
    stub_successful_platform_responses
    stub_successful_platform_logo_responses
    assert_difference("Platform.count", +@ids.count) do
      facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
      facade.find_or_create_platforms
    end
  end

  test "should not create platforms when the igdb request fails" do
    stub_platform_request_failures
    assert_difference("Platform.count", +0) do
      facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
      facade.find_or_create_platforms
    end
  end

  test "should return successfully found or created platforms" do
    stub_successful_platform_responses
    stub_successful_platform_logo_responses
    facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
    igdb_ids = facade.find_or_create_platforms[:platforms].map(&:igdb_id)
    assert_equal igdb_ids, @ids
  end

  test "should return errors for any failed platform igdb api requests" do
    stub_platform_request_failures
    facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
    response = facade.find_or_create_platforms
    response[:errors][:platforms].each_with_index do |error, index|
      assert_equal(error, { @ids[index] => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed platform creations" do
    stub_igdb_api_request_failure("platforms/#{nil}")
    facade = Api::Platforms::CreateFacade.new([nil], @twitch_oauth_token)
    request = facade.find_or_create_platforms
    errors = request[:errors][:platforms]
    assert_equal errors.count, 1
  end

  test "should return errors for any failed platform_logo igdb api requests" do
    stub_platform_logo_request_failures
    stub_successful_platform_responses
    facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
    response = facade.find_or_create_platforms
    assert_equal(
      response[:errors][:platform_logos].count,
      stubbed_platform_logo_ids.count,
    )
  end
end
