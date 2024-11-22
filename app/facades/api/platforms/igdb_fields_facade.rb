class Api::Platforms::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(platform, igdb_data)
    @@platform = platform
    @@igdb_data = igdb_data
  end

  def populate_platform_fields
    @@platform.update(
      abbreviation: abbreviation,
      alternative_name: alternative_name,
      category_enum: category_enum,
      checksum: checksum,
      generation: generation,
      igdb_url: igdb_url,
      name: name,
      slug: slug,
      summary: summary,
    )
  end

  private

  def abbreviation
    get_present_value(@@platform.abbreviation, @@igdb_data["abbreviation"])
  end

  def alternative_name
    get_present_value(
      @@platform.alternative_name,
      @@igdb_data["alternative_name"],
    )
  end

  def category_enum
    get_present_value(@@platform.category_enum, @@igdb_data["category"])
  end

  def checksum
    get_present_value(@@platform.checksum, @@igdb_data["checksum"])
  end

  def generation
    get_present_value(@@platform.generation, @@igdb_data["generation"])
  end

  def igdb_url
    get_present_value(@@platform.igdb_url, @@igdb_data["url"])
  end

  def name
    get_present_value(@@platform.name, @@igdb_data["name"])
  end

  def slug
    get_present_value(@@platform.slug, @@igdb_data["slug"])
  end

  def summary
    get_present_value(@@platform.summary, @@igdb_data["summary"])
  end
end
