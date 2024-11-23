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

  test "#developers should return companies that developed the game" do
    developers = games(:super_metroid).developers
    assert_equal developers, [companies(:nintendo)]
  end

  test "#porters should return companies that ported the game" do
    porters = games(:super_metroid).porters
    assert_equal porters, [companies(:super_metroid_porter)]
  end

  test "#publishers should return companies that published the game" do
    publishers = games(:super_metroid).publishers
    assert_equal publishers, [companies(:super_metroid_publisher)]
  end

  test "#supporters should return companies that published the game" do
    supporters = games(:super_metroid).supporters
    assert_equal supporters, [companies(:super_metroid_supporter)]
  end
end
