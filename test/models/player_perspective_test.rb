require "test_helper"

class PlayerPerspectiveTest < ActiveSupport::TestCase
  test "valid player_perspective" do
    player_perspective = PlayerPerspective.new(igdb_id: 10)
    assert player_perspective.valid?
  end

  test "invalid without igdb_id" do
    player_perspective = PlayerPerspective.new()
    player_perspective.valid?
    assert player_perspective.errors[:igdb_id].include? "can't be blank"
  end
end
