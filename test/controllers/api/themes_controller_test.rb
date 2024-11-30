require "test_helper"

class Api::ThemesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @theme = themes(:one)
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "#index should get index" do
    get api_themes_url, as: :json
    assert_response :success
  end

  test "#index should return the expected index json payload" do
    get api_themes_url, as: :json
    assert_matches_json_schema response, "themes/index"
  end

  test "#show should show theme" do
    get api_theme_url(@theme), as: :json
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get api_theme_url(@theme), as: :json
    assert_matches_json_schema response, "themes/show"
  end

  test "#destroy should destroy theme" do
    assert_difference("Theme.count", -1) do
      delete api_theme_url(@theme), as: :json, headers: @admin_auth_headers
    end
    assert_response :no_content
  end

  test "#destroy should not destroy theme for non-admin users" do
    delete(api_theme_url(@theme), as: :json, headers: @basic_auth_headers)
    assert_response :forbidden
  end
end
