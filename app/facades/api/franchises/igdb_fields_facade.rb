class Api::Franchises::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(franchise, igdb_data)
    @@franchise = franchise
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@franchise.update(
      checksum: checksum,
      igdb_url: igdb_url,
      name: name,
      slug: slug,
    )
  end

  private

  def checksum
    get_present_value(@@franchise.checksum, @@igdb_data["checksum"])
  end

  def igdb_url
    get_present_value(@@franchise.igdb_url, @@igdb_data["url"])
  end

  def name
    get_present_value(@@franchise.name, @@igdb_data["name"])
  end

  def slug
    get_present_value(@@franchise.slug, @@igdb_data["slug"])
  end
end
