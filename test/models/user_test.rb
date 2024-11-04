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
end
