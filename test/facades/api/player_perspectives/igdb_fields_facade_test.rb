require "test_helper"

class Api::PlayerPerspectives::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @player_perspective = PlayerPerspective.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/player_perspectives/3.json"))
    Api::PlayerPerspectives::IgdbFieldsFacade.new(
      @player_perspective,
      @igdb_data,
    ).populate_fields
  end

  test "should populate the checksum" do
    assert_equal(@player_perspective.checksum, @igdb_data["checksum"])
  end

  test "should populate the igdb_url" do
    assert_equal(@player_perspective.igdb_url, @igdb_data["url"])
  end

  test "should populate the name" do
    assert_equal(@player_perspective.name, @igdb_data["name"])
  end

  test "should populate the slug" do
    assert_equal(@player_perspective.slug, @igdb_data["slug"])
  end
end
