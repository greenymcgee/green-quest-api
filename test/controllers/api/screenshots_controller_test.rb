require "test_helper"

class Api::ScreenshotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @screenshot = screenshots(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_screenshots_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_screenshots_url, as: :json
    assert_matches_json_schema response, "screenshots/index"
  end

  test "#show should show screenshot" do
    get api_screenshot_url(@screenshot), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_screenshot_url(@screenshot), as: :json
    assert_matches_json_schema response, "screenshots/show"
  end

  test "#destroy should destroy screenshot" do
    assert_difference("Screenshot.count", -1) do
      delete(
        api_screenshot_url(@screenshot),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "#destroy should not destroy screenshot for non-admin users" do
    delete(
      api_screenshot_url(@screenshot),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
