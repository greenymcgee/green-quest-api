require "test_helper"

class Igdb::ImageFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @resource = Artwork.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/artworks/52607.json"))
    facade = Igdb::ImageFieldsFacade.new(@resource, @igdb_data)
    facade.populate_fields
  end

  test "should populate the alpha_channel" do
    assert_equal(@resource.alpha_channel, @igdb_data["alpha_channel"])
  end

  test "should populate the animated" do
    assert_equal(@resource.animated, @igdb_data["animated"])
  end

  test "should populate the checksum" do
    assert_equal(@resource.checksum, @igdb_data["checksum"])
  end

  test "should populate the height" do
    assert_equal(@resource.height, @igdb_data["height"])
  end

  test "should populate the image_id" do
    assert_equal(@resource.image_id, @igdb_data["image_id"])
  end

  test "should populate the url" do
    assert_equal(@resource.url, @igdb_data["url"])
  end

  test "should populate the width" do
    assert_equal(@resource.width, @igdb_data["width"])
  end
end
