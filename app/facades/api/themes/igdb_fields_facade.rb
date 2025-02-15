class Api::Themes::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(theme, igdb_data)
    @@theme = theme
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@theme.assign_attributes(
      checksum: checksum,
      igdb_url: igdb_url,
      name: name,
      slug: slug,
    )
  end

  private

  def checksum
    get_present_value(@@theme.checksum, @@igdb_data["checksum"])
  end

  def igdb_url
    get_present_value(@@theme.igdb_url, @@igdb_data["url"])
  end

  def name
    get_present_value(@@theme.name, @@igdb_data["name"])
  end

  def slug
    get_present_value(@@theme.slug, @@igdb_data["slug"])
  end
end
