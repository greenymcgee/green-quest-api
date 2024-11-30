class Api::PlayerPerspectives::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(player_perspective, igdb_data)
    @@player_perspective = player_perspective
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@player_perspective.update(
      checksum: checksum,
      igdb_url: igdb_url,
      name: name,
      slug: slug,
    )
  end

  private

  def checksum
    get_present_value(@@player_perspective.checksum, @@igdb_data["checksum"])
  end

  def igdb_url
    get_present_value(@@player_perspective.igdb_url, @@igdb_data["url"])
  end

  def name
    get_present_value(@@player_perspective.name, @@igdb_data["name"])
  end

  def slug
    get_present_value(@@player_perspective.slug, @@igdb_data["slug"])
  end
end
