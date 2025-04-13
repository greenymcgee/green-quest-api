require "test_helper"

class GameFiltersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_game_filters_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_game_filters_url, as: :json
    assert_matches_json_schema response, "game_filters/index"
  end

  test "returns the expected response" do
    Company.stub(:joins, ->(*) { raise StandardError, "DB blew up" }) do
      get api_game_filters_url, as: :json
    end
    assert_matches_json_schema response, "game_filters/index"
  end

  test "returns a 500" do
    Company.stub(:joins, ->(*) { raise StandardError, "DB blew up" }) do
      get api_game_filters_url, as: :json
    end
    assert_response :internal_server_error
  end
end
