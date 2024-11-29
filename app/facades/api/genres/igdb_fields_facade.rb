class Api::Genres::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(genre, igdb_data)
    @@genre = genre
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@genre.update(
      checksum: checksum,
      igdb_url: igdb_url,
      name: name,
      slug: slug,
    )
  end

  private

  def checksum
    get_present_value(@@genre.checksum, @@igdb_data["checksum"])
  end

  def igdb_url
    get_present_value(@@genre.igdb_url, @@igdb_data["url"])
  end

  def name
    get_present_value(@@genre.name, @@igdb_data["name"])
  end

  def slug
    get_present_value(@@genre.slug, @@igdb_data["slug"])
  end
end
