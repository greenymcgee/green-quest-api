class Api::Covers::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(cover, igdb_data)
    @@cover = cover
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@cover.update(
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
      @@cover.alpha_channel,
      @@igdb_data["alpha_channel"],
    )
  end

  def animated
    get_present_boolean_value(@@cover.animated, @@igdb_data["animated"])
  end

  def checksum
    get_present_value(@@cover.checksum, @@igdb_data["checksum"])
  end

  def height
    get_present_value(@@cover.height, @@igdb_data["height"])
  end

  def url
    get_present_value(@@cover.url, @@igdb_data["url"])
  end

  def width
    get_present_value(@@cover.width, @@igdb_data["width"])
  end
end
