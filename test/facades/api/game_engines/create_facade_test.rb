require "test_helper"

class Api::GameEngines::CreateFacadeTest < ActionDispatch::IntegrationTest
  include TwitchOauthTestHelper
  include IgdbApiTestHelper
  include GameEngineCreateTestHelper
  include GameEngineLogoCreateTestHelper

  setup do
    @twitch_bearer_token = stubbed_twitch_bearer_token
    @ids = igdb_game_data["game_engines"]
  end

  test "should create new game_engines" do
    stub_successful_game_engine_responses
    stub_successful_game_engine_logo_responses
    assert_difference("GameEngine.count", +1) do
      facade = Api::GameEngines::CreateFacade.new(@ids, @twitch_bearer_token)
      facade.find_or_create_game_engines
    end
  end

  test "should populate game_engine fields" do
    stub_successful_game_engine_responses
    stub_successful_game_engine_logo_responses
    facade = Api::GameEngines::CreateFacade.new(@ids, @twitch_bearer_token)
    facade.find_or_create_game_engines
    game_engine_json = json_mocks("igdb/game_engines/#{@ids.first}.json")
    game_engine_data = JSON.parse(game_engine_json).first
    assert_equal game_engine_data["name"], GameEngine.last.name
  end

  test "should not create a game_engine when the igdb request fails" do
    stub_game_engine_request_failures
    assert_difference("GameEngine.count", +0) do
      facade = Api::GameEngines::CreateFacade.new(@ids, @twitch_bearer_token)
      facade.find_or_create_game_engines
    end
  end

  test "should return successfully found or created game_engines" do
    stub_successful_game_engine_responses
    stub_successful_game_engine_logo_responses
    facade = Api::GameEngines::CreateFacade.new(@ids, @twitch_bearer_token)
    igdb_ids = facade.find_or_create_game_engines[:game_engines].map(&:igdb_id)
    @ids.each { |id| assert igdb_ids.include? id }
  end

  test "should return errors for any failed game_engine igdb api requests" do
    stub_game_engine_request_failures
    facade = Api::GameEngines::CreateFacade.new(@ids, @twitch_bearer_token)
    response = facade.find_or_create_game_engines
    response[:errors][:game_engines].each_with_index do |error, index|
      assert_equal(error, { @ids[index] => { "message" => "Not authorized" } })
    end
  end

  test "should return errors for any failed game_engine creations" do
    stub_successful_game_engine_logo_responses
    stub_successful_igdb_api_request(
      "game_engines/#{nil}",
      json_mocks("igdb/game_engines/2.json"),
      @twitch_bearer_token,
    )
    facade = Api::GameEngines::CreateFacade.new([nil], @twitch_bearer_token)
    request = facade.find_or_create_game_engines
    errors = request[:errors][:game_engines]
    errors.each { |error| assert_equal(error.message, "can't be blank") }
  end

  test "should return errors for any failed game_engine_logo igdb api requests" do
    stub_game_engine_logo_request_failures
    stub_successful_game_engine_responses
    facade = Api::GameEngines::CreateFacade.new(@ids, @twitch_bearer_token)
    response = facade.find_or_create_game_engines
    assert_equal(@ids.count, response[:errors][:game_engine_logos].count)
  end
end
