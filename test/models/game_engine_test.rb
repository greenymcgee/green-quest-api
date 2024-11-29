require "test_helper"

class GameEngineTest < ActiveSupport::TestCase
  test "valid game_engine" do
    game_engine = GameEngine.new(igdb_id: 10)
    assert game_engine.valid?
  end

  test "invalid without igdb_id" do
    game_engine = GameEngine.new()
    game_engine.valid?
    assert game_engine.errors[:igdb_id].include? "can't be blank"
  end
end
