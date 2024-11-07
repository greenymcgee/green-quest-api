require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:basic_user)
    @auth_headers = set_auth_headers(@user)
  end

  test "should return the expected json payload" do
    post(
      new_user_session_url,
      as: :json,
      params: {
        user: {
          email: @user.email,
          password: "Test123!",
        },
      },
    )
    assert_matches_json_schema response, "users/sessions"
  end

  test "should destroy a user's session" do
    delete destroy_user_session_url, as: :json, headers: @auth_headers
    assert_response :success
  end

  test "should return an unauthorized response without an active user" do
    delete destroy_user_session_url, as: :json
    assert_response :unauthorized
  end
end
