require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = users(:admin_user)
    @admin_auth_headers = set_auth_headers(@admin_user)
    @basic_user = users(:basic_user)
    @basic_auth_headers = set_auth_headers(@basic_user)
  end

  test "should get index for admin user" do
    get identity_users_url, as: :json, headers: @admin_auth_headers
    assert_response :success
  end

  test "should not get index for basic user" do
    get identity_users_url, as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end

  test "should show user when current user is viewing their own record" do
    get identity_user_url(@basic_user), as: :json, headers: @basic_auth_headers
    assert_response :success
  end

  test "should not show user when current user is looking at someone else's record" do
    get identity_user_url(@admin_user), as: :json, headers: @basic_auth_headers
    assert_response :forbidden
  end

  test "should update the user when they are viewing their own record" do
    patch(
      identity_user_url(@basic_user),
      params: {
        user: @basic_user,
      },
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :success
  end

  test "should not update the user when they are viewing someone else's record" do
    patch(
      identity_user_url(@admin_user),
      params: {
        user: @basic_user,
      },
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end

  test "should destroy user when current_user is admin" do
    assert_difference("User.count", -1) do
      delete(
        identity_user_url(@basic_user),
        as: :json,
        headers: @admin_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "should destroy user when current_user is viewing their own record" do
    assert_difference("User.count", -1) do
      delete(
        identity_user_url(@basic_user),
        as: :json,
        headers: @basic_auth_headers,
      )
    end
    assert_response :no_content
  end

  test "should not destroy user when current_user is someone else's record" do
    delete(
      identity_user_url(@admin_user),
      as: :json,
      headers: @basic_auth_headers,
    )
    assert_response :forbidden
  end
end
