require "test_helper"
require "devise/jwt/test_helpers"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
    }
    @auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @user)
  end

  test "should get index" do
    get identity_users_url, as: :json, headers: @auth_headers
    assert_response :success
  end

  test "should show user" do
    get identity_user_url(@user), as: :json, headers: @auth_headers
    assert_response :success
  end

  test "should update user" do
    patch(
      identity_user_url(@user),
      params: {
        user: @user,
      },
      as: :json,
      headers: @auth_headers,
    )
    assert_response :success
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete identity_user_url(@user), as: :json, headers: @auth_headers
    end

    assert_response :no_content
  end
end
