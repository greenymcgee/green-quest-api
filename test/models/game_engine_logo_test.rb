require "test_helper"

class GameEngineLogoTest < ActiveSupport::TestCase
  test "valid game_engine_logo" do
    game_engine_logo =
      GameEngineLogo.new(game_engine: game_engines(:unreal), igdb_id: 10)
    assert game_engine_logo.valid?
  end

  test "invalid without igdb_id" do
    game_engine_logo = GameEngineLogo.new()
    game_engine_logo.valid?
    assert game_engine_logo.errors[:igdb_id].include? "can't be blank"
  end
end
