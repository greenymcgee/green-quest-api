require "test_helper"

class ThemeTest < ActiveSupport::TestCase
  test "valid theme" do
    theme = Theme.new(igdb_id: 10)
    assert theme.valid?
  end

  test "invalid without igdb_id" do
    theme = Theme.new()
    theme.valid?
    assert theme.errors[:igdb_id].include? "can't be blank"
  end
end
