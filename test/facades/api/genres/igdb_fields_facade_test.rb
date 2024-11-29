require "test_helper"

class Api::Genres::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @genre = Genre.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/genres/9.json"))
    facade = Api::Genres::IgdbFieldsFacade.new(@genre, @igdb_data)
    facade.populate_fields
  end

  test "should populate the checksum" do
    assert_equal(@genre.checksum, @igdb_data["checksum"])
  end

  test "should populate the igdb_url" do
    assert_equal(@genre.igdb_url, @igdb_data["url"])
  end

  test "should populate the name" do
    assert_equal(@genre.name, @igdb_data["name"])
  end

  test "should populate the slug" do
    assert_equal(@genre.slug, @igdb_data["slug"])
  end
end
