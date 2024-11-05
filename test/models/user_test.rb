require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user =
      User.new(
        email: "test@test.com",
        password: "Test123!",
        roles: ["Basic"],
        username: "username",
      )
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new()
    assert_not_nil user.errors[:email]
  end

  test "invalid without roles" do
    user = User.new()
    assert_not_nil user.errors[:roles]
  end

  test "invalid without username" do
    user = User.new()
    assert_not_nil user.errors[:username]
  end

  test "admin? true" do
    user = users(:admin_user)
    assert user.admin?
  end

  test "admin? false" do
    user = users(:basic_user)
    assert_not user.admin?
  end
end
