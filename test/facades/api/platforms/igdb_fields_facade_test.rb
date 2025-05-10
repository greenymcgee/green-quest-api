require "test_helper"

class Api::Platforms::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @platform = Platform.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/platforms/19.json"))
    facade = Api::Platforms::IgdbFieldsFacade.new(@platform, @igdb_data)
    facade.populate_fields
  end

  test "should populate the abbreviation" do
    assert_equal(@platform.abbreviation, @igdb_data["abbreviation"])
  end

  test "should populate the alternative_name" do
    assert_equal(@platform.alternative_name, @igdb_data["alternative_name"])
  end

  test "should populate the category_enum" do
    assert_equal(@platform.category_enum, @igdb_data["category"])
  end

  test "should populate the checksum" do
    assert_equal(@platform.checksum, @igdb_data["checksum"])
  end

  test "should populate the generation" do
    assert_equal(@platform.generation, @igdb_data["generation"])
  end

  test "should populate the igdb_url" do
    assert_equal(@platform.igdb_url, @igdb_data["url"])
  end

  test "should populate the name" do
    assert_equal(@platform.name, @igdb_data["name"])
  end

  test "should populate the slug" do
    assert_equal(@platform.slug, @igdb_data["slug"])
  end

  test "should populate the summary" do
    assert_equal(@platform.summary, @igdb_data["summary"])
  end
end
