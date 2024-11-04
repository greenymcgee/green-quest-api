require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:ned_flanders)
    @auth_headers = set_auth_headers(@user)
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
