require "test_helper"

class Api::Artworks::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @artwork = Artwork.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/artworks/52607.json"))
    facade = Api::Artworks::IgdbFieldsFacade.new(@artwork, @igdb_data)
    facade.populate_fields
  end

  test "should populate the alpha_channel" do
    assert_equal(@artwork.alpha_channel, @igdb_data["alpha_channel"])
  end

  test "should populate the animated" do
    assert_equal(@artwork.animated, @igdb_data["animated"])
  end

  test "should populate the checksum" do
    assert_equal(@artwork.checksum, @igdb_data["checksum"])
  end

  test "should populate the height" do
    assert_equal(@artwork.height, @igdb_data["height"])
  end

  test "should populate the url" do
    assert_equal(@artwork.url, @igdb_data["url"])
  end

  test "should populate the width" do
    assert_equal(@artwork.width, @igdb_data["width"])
  end
end
