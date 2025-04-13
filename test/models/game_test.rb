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

  test "#by_query when query is present" do
    games = Game.by_query("metroid")
    assert_equal games, [games(:super_metroid)]
  end

  test "#by_query when query is blank" do
    games = Game.by_query(nil)
    expected_games = Game.all
    games.each_with_index do |game, index|
      assert_equal(game, expected_games[index])
    end
  end

  test "#by_platforms when platforms are present" do
    snes_id = platforms(:snes).id
    switch_id = platforms(:switch).id
    games = Game.by_platforms([snes_id, switch_id])
    assert_equal games, [games(:super_metroid)]
  end

  test "#by_platforms when platforms are blank" do
    games = Game.by_platforms(nil)
    assert_equal games, Game.all
  end

  test "#by_genres when genres are present" do
    rpg_id = genres(:rpg).id
    games = Game.by_genres([rpg_id])
    assert_equal games, [games(:dark_souls)]
  end

  test "#by_genres when genres are blank" do
    games = Game.by_genres(nil)
    assert_equal games, Game.all
  end

  test "#by_companies when companies are present" do
    fromsoft_id = companies(:fromsoft).id
    games = Game.by_companies([fromsoft_id])
    assert_equal games, [games(:dark_souls)]
  end

  test "#by_companies when companies are blank" do
    games = Game.by_companies(nil)
    assert_equal games, Game.all
  end

  test "#developers should return companies that developed the game" do
    developers = games(:super_metroid).developers
    assert_equal developers, [companies(:nintendo)]
  end

  test "#porters should return companies that ported the game" do
    porters = games(:super_metroid).porters
    assert_equal porters, [companies(:super_metroid_porter)]
  end

  test "#published? should be true when the published_at date is less than now" do
    game = games(:super_metroid)
    game.update(published_at: "1-1-1999")
    game.save
    assert_equal true, game.published?
  end

  test "#published? be false when the published_at date is greater than now" do
    game = games(:super_metroid)
    game.update(published_at: Date.tomorrow)
    assert_equal false, game.published?
  end

  test "#published? be false when the published_at date is blank" do
    game = games(:super_metroid)
    assert_equal false, game.published?
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
