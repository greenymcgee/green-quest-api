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
    user.valid?
    assert user.errors[:email].include? "can't be blank"
  end

  test "invalid without roles" do
    user = User.new()
    user.valid?
    assert user.errors[:roles].include? "can't be blank"
  end

  test "invalid without username" do
    user = User.new()
    user.valid?
    assert user.errors[:username].include? "can't be blank"
  end

  test "invalid without password complexity" do
    user = User.new({ password: "bob" })
    user.valid?
    assert user.errors[:password].include? PASSWORD_COMPLEXITY_ERROR_MESSAGE
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
