class Api::Screenshots::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(screenshot, igdb_data)
    @@screenshot = screenshot
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@screenshot.update(
      alpha_channel: alpha_channel,
      animated: animated,
      checksum: checksum,
      height: height,
      url: url,
      width: width,
    )
  end

  private

  def alpha_channel
    get_present_boolean_value(
      @@screenshot.alpha_channel,
      @@igdb_data["alpha_channel"],
    )
  end

  def animated
    get_present_boolean_value(@@screenshot.animated, @@igdb_data["animated"])
  end

  def checksum
    get_present_value(@@screenshot.checksum, @@igdb_data["checksum"])
  end

  def height
    get_present_value(@@screenshot.height, @@igdb_data["height"])
  end

  def url
    get_present_value(@@screenshot.url, @@igdb_data["url"])
  end

  def width
    get_present_value(@@screenshot.width, @@igdb_data["width"])
  end
end
