require "test_helper"

class Api::Games::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @game = Game.new(igdb_id: 1026)
    @igdb_game_data, = JSON.parse(json_mocks("igdb/game.json"))
    facade = Api::Games::IgdbFieldsFacade.new(@game, @igdb_game_data)
    facade.populate_game_fields
  end

  test "should populate the bundle_ids" do
    assert_equal(@game.bundle_ids, @igdb_game_data["bundles"])
  end

  test "should populate the dlc_ids" do
    assert_equal(@game.dlc_ids, @igdb_game_data["dlcs"])
  end

  test "should populate the expanded_game_ids" do
    assert_equal(@game.expanded_game_ids, @igdb_game_data["expanded_games"])
  end

  test "should populate the expansion_ids" do
    assert_equal(@game.expansion_ids, @igdb_game_data["expansions"])
  end

  test "should populate the fork_ids" do
    assert_equal(@game.fork_ids, @igdb_game_data["forks"])
  end

  test "should populate the parent_game_id" do
    assert_equal(@game.parent_game_id, @igdb_game_data["parent_game"])
  end

  test "should populate the port_ids" do
    assert_equal(@game.port_ids, @igdb_game_data["ports"])
  end

  test "should populate the remake_ids" do
    assert_equal(@game.remake_ids, @igdb_game_data["remakes"])
  end

  test "should populate the remaster_ids" do
    assert_equal(@game.remaster_ids, @igdb_game_data["remasters"])
  end

  test "should populate the similar_game_ids" do
    assert_equal(@game.similar_game_ids, @igdb_game_data["similar_games"])
  end

  test "should populate the standalone_expansion_ids" do
    assert_equal(
      @game.standalone_expansion_ids,
      @igdb_game_data["standalone_expansions"],
    )
  end

  test "should populate the version_parent_id" do
    assert_equal(@game.version_parent_id, @igdb_game_data["version_parent"])
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
