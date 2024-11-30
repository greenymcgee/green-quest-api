require "test_helper"

class Api::Themes::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @theme = Theme.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/themes/1.json"))
    Api::Themes::IgdbFieldsFacade.new(@theme, @igdb_data).populate_fields
  end

  test "should populate the checksum" do
    assert_equal(@theme.checksum, @igdb_data["checksum"])
  end

  test "should populate the igdb_url" do
    assert_equal(@theme.igdb_url, @igdb_data["url"])
  end

  test "should populate the name" do
    assert_equal(@theme.name, @igdb_data["name"])
  end

  test "should populate the slug" do
    assert_equal(@theme.slug, @igdb_data["slug"])
  end
end
