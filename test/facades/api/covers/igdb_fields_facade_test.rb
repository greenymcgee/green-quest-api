require "test_helper"

class Api::Covers::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @cover = Cover.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/covers/181427.json"))
    facade = Api::Covers::IgdbFieldsFacade.new(@cover, @igdb_data)
    facade.populate_fields
  end

  test "should populate the alpha_channel" do
    assert_equal(@cover.alpha_channel, @igdb_data["alpha_channel"])
  end

  test "should populate the animated" do
    assert_equal(@cover.animated, @igdb_data["animated"])
  end

  test "should populate the checksum" do
    assert_equal(@cover.checksum, @igdb_data["checksum"])
  end

  test "should populate the height" do
    assert_equal(@cover.height, @igdb_data["height"])
  end

  test "should populate the url" do
    assert_equal(@cover.url, @igdb_data["url"])
  end

  test "should populate the width" do
    assert_equal(@cover.width, @igdb_data["width"])
  end
end
