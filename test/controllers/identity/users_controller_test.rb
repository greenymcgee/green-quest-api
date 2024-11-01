require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get identity_users_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post identity_users_url, params: { user: @user }, as: :json
    end

    assert_response :created
  end

  test "should show user" do
    get identity_user_url(@user), as: :json
    assert_response :success
  end

  test "should update user" do
    patch identity_user_url(@user), params: { user: @user }, as: :json
    assert_response :success
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete identity_user_url(@user), as: :json
    end

    assert_response :no_content
  end
end
