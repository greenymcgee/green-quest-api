require "test_helper"

class Api::GameEngines::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @game_engine = GameEngine.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/game_engines/2.json"))
    facade = Api::GameEngines::IgdbFieldsFacade.new(@game_engine, @igdb_data)
    facade.populate_fields
  end

  test "should populate the checksum" do
    assert_equal(@game_engine.checksum, @igdb_data["checksum"])
  end

  test "should populate the description" do
    assert_equal(@game_engine.description, @igdb_data["description"])
  end

  test "should populate the igdb_url" do
    assert_equal(@game_engine.igdb_url, @igdb_data["url"])
  end

  test "should populate the name" do
    assert_equal(@game_engine.name, @igdb_data["name"])
  end

  test "should populate the slug" do
    assert_equal(@game_engine.slug, @igdb_data["slug"])
  end
end
