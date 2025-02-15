class Api::Websites::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(website, igdb_data)
    @@website = website
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@website.assign_attributes(
      category_enum: category_enum,
      checksum: checksum,
      trusted: trusted,
      url: url,
    )
  end

  private

  def category_enum
    get_present_value(@@website.category_enum, @@igdb_data["category"])
  end

  def checksum
    get_present_value(@@website.checksum, @@igdb_data["checksum"])
  end

  def url
    get_present_value(@@website.url, @@igdb_data["url"])
  end

  def trusted
    get_present_boolean_value(@@website.trusted, @@igdb_data["trusted"])
  end
end
