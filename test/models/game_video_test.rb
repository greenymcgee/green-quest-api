require "test_helper"

class GameVideoTest < ActiveSupport::TestCase
  test "valid GameVideo" do
    game_video = GameVideo.new(game: games(:super_metroid), igdb_id: 10)
    assert game_video.valid?
  end

  test "invalid without igdb_id" do
    game_video = GameVideo.new()
    game_video.valid?
    assert game_video.errors[:igdb_id].include? "can't be blank"
  end
end
