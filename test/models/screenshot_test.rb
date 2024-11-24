require "test_helper"

class ScreenshotTest < ActiveSupport::TestCase
  test "valid screenshot" do
    screenshot = Screenshot.new(igdb_id: 10)
    assert screenshot.valid?
  end

  test "invalid without igdb_id" do
    screenshot = Screenshot.new()
    screenshot.valid?
    assert screenshot.errors[:igdb_id].include? "can't be blank"
  end
end
