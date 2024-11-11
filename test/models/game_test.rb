require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "valid game" do
    game = Game.new(igdb_id: 10)
    assert game.valid?
  end

  test "invalid without igdb_id" do
    game = Game.new()
    game.valid?
    assert game.errors[:igdb_id].include? "can't be blank"
  end
end
