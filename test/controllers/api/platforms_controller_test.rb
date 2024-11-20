require "test_helper"

class PlatformsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @platform = platforms(:snes)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "should get index" do
    get api_platforms_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_platforms_url, as: :json
    assert_matches_json_schema response, "platforms/index"
  end

  test "should show platform" do
    get api_platform_url(@platform), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_platform_url(@platform), as: :json
    assert_matches_json_schema response, "platforms/show"
  end

  test "should destroy platform" do
    assert_difference("Platform.count", -1) do
      delete(
        api_platform_url(@platform),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy platform for non-admin users" do
    delete api_platform_url(@platform), as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end
end
