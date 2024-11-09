require "test_helper"

class ResetPasswordsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:admin_user) }

  test "should return a created status" do
    post(api_reset_password_url, params: { email: @user.email }, as: :json)
    assert_response :created
  end

  test "should return an unproccessible entity status" do
    post(api_reset_password_url, as: :json)
    assert_response :unprocessable_entity
  end

  test "should send reset password instructions" do
    post(api_reset_password_url, params: { email: @user.email }, as: :json)
    delivery, = ActionMailer::Base.deliveries
    assert_equal @user.email, delivery["to"].to_s
  end

  test "should return a success response" do
    token = @user.send_reset_password_instructions
    patch(
      api_reset_password_url(@reset_password),
      params: {
        password: "Newpassword123!",
        password_confirmation: "Newpassword123!",
        token: token,
      },
      as: :json,
    )
    assert_response :success
  end

  test "should return an unproccessible entity response" do
    patch(
      api_reset_password_url(@reset_password),
      params: {
        password: "Newpassword123!",
        password_confirmation: "Newpassword123!",
      },
      as: :json,
    )
    assert_response :unprocessable_entity
  end
end
