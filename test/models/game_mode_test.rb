require "test_helper"

class GameModeTest < ActiveSupport::TestCase
  test "valid game_mode" do
    game_mode = GameMode.new(igdb_id: 10)
    assert game_mode.valid?
  end

  test "invalid without igdb_id" do
    game_mode = GameMode.new()
    game_mode.valid?
    assert game_mode.errors[:igdb_id].include? "can't be blank"
  end
end
