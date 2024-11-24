class Api::Artworks::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(artwork, igdb_data)
    @@artwork = artwork
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@artwork.update(
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
      @@artwork.alpha_channel,
      @@igdb_data["alpha_channel"],
    )
  end

  def animated
    get_present_boolean_value(@@artwork.animated, @@igdb_data["animated"])
  end

  def checksum
    get_present_value(@@artwork.checksum, @@igdb_data["checksum"])
  end

  def height
    get_present_value(@@artwork.height, @@igdb_data["height"])
  end

  def url
    get_present_value(@@artwork.url, @@igdb_data["url"])
  end

  def width
    get_present_value(@@artwork.width, @@igdb_data["width"])
  end
end
