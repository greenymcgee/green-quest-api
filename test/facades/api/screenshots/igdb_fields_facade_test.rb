require "test_helper"

class Api::Screenshots::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @screenshot = Screenshot.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/screenshots/176243.json"))
    facade = Api::Screenshots::IgdbFieldsFacade.new(@screenshot, @igdb_data)
    facade.populate_fields
  end

  test "should populate the alpha_channel" do
    assert_equal(@screenshot.alpha_channel, false)
  end

  test "should populate the animated" do
    assert_equal(@screenshot.animated, false)
  end

  test "should populate the checksum" do
    assert_equal(@screenshot.checksum, @igdb_data["checksum"])
  end

  test "should populate the height" do
    assert_equal(@screenshot.height, @igdb_data["height"])
  end

  test "should populate the url" do
    assert_equal(@screenshot.url, @igdb_data["url"])
  end

  test "should populate the width" do
    assert_equal(@screenshot.width, @igdb_data["width"])
  end
end
