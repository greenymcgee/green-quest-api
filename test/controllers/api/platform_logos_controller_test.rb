require "test_helper"

class Api::PlatformLogosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @platform_logo = platform_logos(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#should get index" do
    get api_platform_logos_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_platform_logos_url, as: :json
    assert_matches_json_schema response, "platform_logos/index"
  end

  test "#show should show platform_logo" do
    get api_platform_logo_url(@platform_logo), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_platform_logo_url(@platform_logo), as: :json
    assert_matches_json_schema response, "platform_logos/show"
  end

  test "#destroy should destroy platform_logo" do
    assert_difference("PlatformLogo.count", -1) do
      delete(
        api_platform_logo_url(@platform_logo),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy platform_logo for non-admin users" do
    delete(
      api_platform_logo_url(@platform_logo),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
