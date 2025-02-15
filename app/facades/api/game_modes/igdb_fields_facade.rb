class Api::GameModes::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(game_mode, igdb_data)
    @@game_mode = game_mode
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@game_mode.assign_attributes(
      checksum: checksum,
      igdb_url: igdb_url,
      name: name,
      slug: slug,
    )
  end

  private

  def checksum
    get_present_value(@@game_mode.checksum, @@igdb_data["checksum"])
  end

  def igdb_url
    get_present_value(@@game_mode.igdb_url, @@igdb_data["url"])
  end

  def name
    get_present_value(@@game_mode.name, @@igdb_data["name"])
  end

  def slug
    get_present_value(@@game_mode.slug, @@igdb_data["slug"])
  end
end
