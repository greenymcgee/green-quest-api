require "test_helper"

class Api::GameEnginesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_engine = game_engines(:unreal)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_game_engines_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_game_engines_url, as: :json
    assert_matches_json_schema response, "game_engines/index"
  end

  test "#show should show game_engine" do
    get api_game_engine_url(@game_engine), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_game_engine_url(@game_engine), as: :json
    assert_matches_json_schema response, "game_engines/show"
  end

  test "#destroy should destroy game_engine" do
    assert_difference("GameEngine.count", -1) do
      delete(
        api_game_engine_url(@game_engine),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy game_engine for non-admin users" do
    delete(
      api_game_engine_url(@game_engine),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
