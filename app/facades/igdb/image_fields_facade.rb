class Igdb::ImageFieldsFacade
  include IgdbFieldsHelper

  def initialize(resource, igdb_data)
    @@resource = resource
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@resource.assign_attributes(
      alpha_channel: alpha_channel,
      animated: animated,
      checksum: checksum,
      height: height,
      image_id: image_id,
      url: url,
      width: width,
    )
  end

  private

  def alpha_channel
    get_present_boolean_value(
      @@resource.alpha_channel,
      @@igdb_data["alpha_channel"],
    )
  end

  def animated
    get_present_boolean_value(@@resource.animated, @@igdb_data["animated"])
  end

  def checksum
    get_present_value(@@resource.checksum, @@igdb_data["checksum"])
  end

  def height
    get_present_value(@@resource.height, @@igdb_data["height"])
  end

  def image_id
    get_present_value(@@resource.image_id, @@igdb_data["image_id"])
  end

  def url
    get_present_value(@@resource.url, @@igdb_data["url"])
  end

  def width
    get_present_value(@@resource.width, @@igdb_data["width"])
  end
end
