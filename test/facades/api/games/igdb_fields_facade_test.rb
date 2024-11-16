require "test_helper"

class Api::Games::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @game = Game.new(igdb_id: 1026)
    @igdb_game_data, = JSON.parse(json_mocks("igdb/game.json"))
    facade = Api::Games::IgdbFieldsFacade.new(@game, @igdb_game_data)
    facade.populate_game_fields
  end

  test "should populate the category_enum" do
    assert_equal(@game.category_enum, @igdb_game_data["category"])
  end

  test "should populate the checksum" do
    assert_equal(@game.checksum, @igdb_game_data["checksum"])
  end

  test "should populate the first_release_date" do
    igdb_date = @igdb_game_data["first_release_date"]
    date = Time.at(igdb_date).utc.to_datetime
    assert_equal(@game.first_release_date, date)
  end

  test "should populate the name" do
    assert_equal(@game.name, @igdb_game_data["name"])
  end

  test "should populate the slug" do
    assert_equal(@game.slug, @igdb_game_data["slug"])
  end

  test "should populate the status" do
    assert_equal(@game.status, @igdb_game_data["status"])
  end

  test "should populate the storyline" do
    assert_equal(@game.storyline, @igdb_game_data["storyline"])
  end

  test "should populate the summary" do
    assert_equal(@game.summary, @igdb_game_data["summary"])
  end

  test "should populate the version_title" do
    assert_equal(@game.version_title, @igdb_game_data["version_title"])
  end
end
