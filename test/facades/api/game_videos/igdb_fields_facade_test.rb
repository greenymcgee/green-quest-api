require "test_helper"

class Api::GameVideos::IgdbFieldsFacadeTest < ActionDispatch::IntegrationTest
  setup do
    @game_video = GameVideo.new(igdb_id: 1026)
    @igdb_data, = JSON.parse(json_mocks("igdb/game_videos/715.json"))
    facade = Api::GameVideos::IgdbFieldsFacade.new(@game_video, @igdb_data)
    facade.populate_fields
  end

  test "should populate the checksum" do
    assert_equal(@game_video.checksum, @igdb_data["checksum"])
  end

  test "should populate the name" do
    assert_equal(@game_video.name, @igdb_data["name"])
  end

  test "should populate the video_id" do
    assert_equal(@game_video.video_id, @igdb_data["video_id"])
  end
end
