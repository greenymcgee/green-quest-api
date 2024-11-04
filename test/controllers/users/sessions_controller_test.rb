require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:ned_flanders)
    @auth_headers = set_auth_headers(@user)
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
