require "test_helper"

class Api::Franchises::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @franchise = Franchise.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/franchises/596.json"))
    facade = Api::Franchises::IgdbFieldsFacade.new(@franchise, @igdb_data)
    facade.populate_franchise_fields
  end

  test "should populate the checksum" do
    assert_equal(@franchise.checksum, @igdb_data["checksum"])
  end

  test "should populate the igdb_url" do
    assert_equal(@franchise.igdb_url, @igdb_data["url"])
  end

  test "should populate the name" do
    assert_equal(@franchise.name, @igdb_data["name"])
  end

  test "should populate the slug" do
    assert_equal(@franchise.slug, @igdb_data["slug"])
  end
end
