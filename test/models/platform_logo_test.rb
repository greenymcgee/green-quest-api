require "test_helper"

class PlatformLogoTest < ActiveSupport::TestCase
  test "valid platform_logo" do
    platform_logo = PlatformLogo.new(igdb_id: 10, platform: platforms(:snes))
    assert platform_logo.valid?
  end

  test "invalid without igdb_id" do
    platform_logo = PlatformLogo.new()
    platform_logo.valid?
    assert platform_logo.errors[:igdb_id].include? "can't be blank"
  end
end
