class Api::GameVideos::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(game_video, igdb_data)
    @@game_video = game_video
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@game_video.assign_attributes(
      checksum: checksum,
      name: name,
      video_id: video_id,
    )
  end

  private

  def checksum
    get_present_value(@@game_video.checksum, @@igdb_data["checksum"])
  end

  def name
    get_present_value(@@game_video.name, @@igdb_data["name"])
  end

  def video_id
    get_present_value(@@game_video.video_id, @@igdb_data["video_id"])
  end
end
