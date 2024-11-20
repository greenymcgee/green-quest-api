require "test_helper"

class PlatformTest < ActiveSupport::TestCase
  test "valid platform" do
    platform = Platform.new(igdb_id: 10)
    assert platform.valid?
  end

  test "invalid without igdb_id" do
    platform = Platform.new()
    platform.valid?
    assert platform.errors[:igdb_id].include? "can't be blank"
  end
end
