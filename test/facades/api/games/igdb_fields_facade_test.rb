require "test_helper"

class Api::Games::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @game = Game.new(igdb_id: 1026)
    @igdb_game_data, = JSON.parse(json_mocks("igdb/game.json"))
    facade = Api::Games::IgdbFieldsFacade.new(@game, @igdb_game_data)
    facade.populate_game_fields
  end

  test "should populate the age_rating_ids" do
    assert_equal(@game.age_rating_ids, @igdb_game_data["age_ratings"])
  end

  test "should populate the alternative_name_ids" do
    assert_equal(
      @game.alternative_name_ids,
      @igdb_game_data["alternative_names"],
    )
  end

  test "should populate the artwork_ids" do
    assert_equal(@game.artwork_ids, @igdb_game_data["artworks"])
  end

  test "should populate the bundle_ids" do
    assert_equal(@game.bundle_ids, @igdb_game_data["bundles"])
  end

  test "should populate the category_enum" do
    assert_equal(@game.category_enum, @igdb_game_data["category"])
  end

  test "should populate the checksum" do
    assert_equal(@game.checksum, @igdb_game_data["checksum"])
  end

  test "should populate the collection_id" do
    assert_equal(@game.collection_id, @igdb_game_data["collection"])
  end

  test "should populate the collection_ids" do
    assert_equal(@game.collection_ids, @igdb_game_data["collections"])
  end

  test "should populate the cover_id" do
    assert_equal(@game.cover_id, @igdb_game_data["cover"])
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

  test "should populate the external_game_ids" do
    assert_equal(@game.external_game_ids, @igdb_game_data["external_games"])
  end

  test "should populate the first_release_date" do
    igdb_date = @igdb_game_data["first_release_date"]
    date = Time.at(igdb_date).utc.to_datetime
    assert_equal(@game.first_release_date, date)
  end

  test "should populate the fork_ids" do
    assert_equal(@game.fork_ids, @igdb_game_data["forks"])
  end

  test "should populate the franchise_id" do
    assert_equal(@game.franchise_id, @igdb_game_data["franchise"])
  end

  test "should populate the franchise_ids" do
    assert_equal(@game.franchise_ids, @igdb_game_data["franchises"])
  end

  test "should populate the game_engine_ids" do
    assert_equal(@game.game_engine_ids, @igdb_game_data["game_engines"])
  end

  test "should populate the game_localization_ids" do
    assert_equal(
      @game.game_localization_ids,
      @igdb_game_data["game_localizations"],
    )
  end

  test "should populate the game_mode_ids" do
    assert_equal(@game.game_mode_ids, @igdb_game_data["game_modes"])
  end

  test "should populate the genre_ids" do
    assert_equal(@game.genre_ids, @igdb_game_data["genres"])
  end

  test "should populate the involved_company_ids" do
    assert_equal(
      @game.involved_company_ids,
      @igdb_game_data["involved_companies"],
    )
  end

  test "should populate the keyword_ids" do
    assert_equal(@game.keyword_ids, @igdb_game_data["keywords"])
  end

  test "should populate the language_support_ids" do
    assert_equal(
      @game.language_support_ids,
      @igdb_game_data["language_supports"],
    )
  end

  test "should populate the multiplayer_mode_ids" do
    assert_equal(
      @game.multiplayer_mode_ids,
      @igdb_game_data["multiplayer_modes"],
    )
  end

  test "should populate the name" do
    assert_equal(@game.name, @igdb_game_data["name"])
  end

  test "should populate the parent_game_id" do
    assert_equal(@game.parent_game_id, @igdb_game_data["parent_game"])
  end

  test "should populate the platform_ids" do
    assert_equal(@game.platform_ids, @igdb_game_data["platforms"])
  end

  test "should populate the player_perspective_ids" do
    assert_equal(
      @game.player_perspective_ids,
      @igdb_game_data["player_perspectives"],
    )
  end

  test "should populate the port_ids" do
    assert_equal(@game.port_ids, @igdb_game_data["ports"])
  end

  test "should populate the release_date_ids" do
    assert_equal(@game.release_date_ids, @igdb_game_data["release_dates"])
  end

  test "should populate the remake_ids" do
    assert_equal(@game.remake_ids, @igdb_game_data["remakes"])
  end

  test "should populate the remaster_ids" do
    assert_equal(@game.remaster_ids, @igdb_game_data["remasters"])
  end

  test "should populate the screenshot_ids" do
    assert_equal(@game.screenshot_ids, @igdb_game_data["screenshots"])
  end

  test "should populate the similar_game_ids" do
    assert_equal(@game.similar_game_ids, @igdb_game_data["similar_games"])
  end

  test "should populate the slug" do
    assert_equal(@game.slug, @igdb_game_data["slug"])
  end

  test "should populate the standalone_expansion_ids" do
    assert_equal(
      @game.standalone_expansion_ids,
      @igdb_game_data["standalone_expansions"],
    )
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

  test "should populate the tag_ids" do
    assert_equal(@game.tag_ids, @igdb_game_data["tags"])
  end

  test "should populate the theme_ids" do
    assert_equal(@game.theme_ids, @igdb_game_data["themes"])
  end

  test "should populate the version_parent_id" do
    assert_equal(@game.version_parent_id, @igdb_game_data["version_parent"])
  end

  test "should populate the version_title" do
    assert_equal(@game.version_title, @igdb_game_data["version_title"])
  end

  test "should populate the video_ids" do
    assert_equal(@game.video_ids, @igdb_game_data["videos"])
  end

  test "should populate the website_ids" do
    assert_equal(@game.website_ids, @igdb_game_data["websites"])
  end
end
