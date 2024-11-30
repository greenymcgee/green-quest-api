require "test_helper"

class Api::PlayerPerspectivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player_perspective = player_perspectives(:first_person)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_player_perspectives_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_player_perspectives_url, as: :json
    assert_matches_json_schema response, "player_perspectives/index"
  end

  test "#show should show player_perspective" do
    get api_player_perspective_url(@player_perspective), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_player_perspective_url(@player_perspective), as: :json
    assert_matches_json_schema response, "player_perspectives/show"
  end

  test "#destroy should destroy player_perspective" do
    assert_difference("PlayerPerspective.count", -1) do
      delete(
        api_player_perspective_url(@player_perspective),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy player_perspective for non-admin users" do
    delete(
      api_player_perspective_url(@player_perspective),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
