require "test_helper"

class Api::Websites::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @website = Website.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/websites/53240.json"))
    facade = Api::Websites::IgdbFieldsFacade.new(@website, @igdb_data)
    facade.populate_fields
  end

  test "should populate the category_enum" do
    assert_equal(@website.category_enum, @igdb_data["category"])
  end

  test "should populate the checksum" do
    assert_equal(@website.checksum, @igdb_data["checksum"])
  end

  test "should populate the trusted" do
    assert_equal(@website.trusted, @igdb_data["trusted"])
  end

  test "should populate the url" do
    assert_equal(@website.url, @igdb_data["url"])
  end
end
