require "test_helper"

class Api::GameModes::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @game_mode = GameMode.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/game_modes/1.json"))
    facade = Api::GameModes::IgdbFieldsFacade.new(@game_mode, @igdb_data)
    facade.populate_fields
  end

  test "should populate the checksum" do
    assert_equal(@game_mode.checksum, @igdb_data["checksum"])
  end

  test "should populate the igdb_url" do
    assert_equal(@game_mode.igdb_url, @igdb_data["url"])
  end

  test "should populate the name" do
    assert_equal(@game_mode.name, @igdb_data["name"])
  end

  test "should populate the slug" do
    assert_equal(@game_mode.slug, @igdb_data["slug"])
  end
end
