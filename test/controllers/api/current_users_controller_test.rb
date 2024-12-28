require "test_helper"

class Api::CurrentUsersControllerTest < ActionDispatch::IntegrationTest
  setup { @admin_auth_headers = set_auth_headers(users(:admin_user)) }

  test "#show should show the current_user" do
    get(api_current_user_url, as: :json, headers: @admin_auth_headers)
    assert_response :success
  end

  test "#show should return the expected show json payload" do
    get(api_current_user_url, as: :json, headers: @admin_auth_headers)
    assert_matches_json_schema response, "users/show"
  end

  test "#show should return an unauthorized error" do
    get(api_current_user_url, as: :json)
    assert_response :unauthorized
  end
end
