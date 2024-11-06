require "test_helper"

class ResgistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should sign a valid user up" do
    post(
      user_registration_url,
      as: :json,
      params: {
        user: {
          email: "test@test.com",
          password: "Test123!",
          roles: ["Basic"],
          username: "rubyjean",
        },
      },
    )
    assert_response :success
  end

  test "should return the expected json payload" do
    post(
      user_registration_url,
      as: :json,
      params: {
        user: {
          email: "test@test.com",
          first_name: "Ruby",
          password: "Test123!",
          roles: ["Basic"],
          username: "rubyjean",
        },
      },
    )
    assert_matches_json_schema response, "users/show"
  end

  test "should reject an invalid user" do
    post(
      user_registration_url,
      as: :json,
      params: {
        user: {
          email: "test@test.com",
          roles: ["Basic"],
          username: "rubyjean",
        },
      },
    )
    assert_response :unprocessable_entity
  end
end
