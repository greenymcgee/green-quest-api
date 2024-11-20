require "test_helper"

class Api::Platforms::CreateFacadeTest < ActionDispatch::IntegrationTest
  include IgdbApiTestHelper

  setup do
    @twitch_oauth_token = "Bearer asdlfkh"
    @ids = JSON.parse(json_mocks("igdb/game.json")).first["platforms"]
  end

  test "should create new genres" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "platforms/#{id}",
        json_mocks("igdb/platforms/#{id}.json"),
        @twitch_oauth_token,
      )
    end
    assert_difference("Platform.count", +5) do
      facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
      facade.find_or_create_platforms
    end
  end

  test "should not create platforms when the igdb request fails" do
    @ids.each { |id| stub_igdb_api_request_failure("platforms/#{id}") }
    assert_difference("Platform.count", +0) do
      facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
      facade.find_or_create_platforms
    end
  end

  test "should return successfully found or created platforms" do
    @ids.each do |id|
      stub_successful_igdb_api_request(
        "platforms/#{id}",
        json_mocks("igdb/platforms/#{id}.json"),
        @twitch_oauth_token,
      )
    end
    facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
    igdb_ids = facade.find_or_create_platforms[:platforms].map(&:igdb_id)
    assert_equal igdb_ids, @ids
  end

  test "should return errors for any failed igdb api requests" do
    @ids.each { |id| stub_igdb_api_request_failure("platforms/#{id}") }
    facade = Api::Platforms::CreateFacade.new(@ids, @twitch_oauth_token)
    response = facade.find_or_create_platforms
    response[:errors].each_with_index do |error, index|
      # 19 is already saved so we skip it
      id = index > 0 ? @ids[index + 1] : @ids[index]
      assert_equal(error, { id => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed platform creations" do
    stub_successful_igdb_api_request(
      "platforms/#{nil}",
      json_mocks("igdb/platforms/5.json"),
      @twitch_oauth_token,
    )
    facade = Api::Platforms::CreateFacade.new([nil], @twitch_oauth_token)
    request = facade.find_or_create_platforms
    errors = request[:errors]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end
end
