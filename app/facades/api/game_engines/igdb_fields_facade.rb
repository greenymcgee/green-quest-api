class Api::GameEngines::IgdbFieldsFacade
  include IgdbFieldsHelper

  def initialize(game_engine, igdb_data)
    @@game_engine = game_engine
    @@igdb_data = igdb_data
  end

  def populate_fields
    @@game_engine.assign_attributes(
      checksum: checksum,
      description: description,
      igdb_url: igdb_url,
      name: name,
      slug: slug,
    )
  end

  private

  def checksum
    get_present_value(@@game_engine.checksum, @@igdb_data["checksum"])
  end

  def description
    get_present_value(@@game_engine.description, @@igdb_data["description"])
  end

  def igdb_url
    get_present_value(@@game_engine.igdb_url, @@igdb_data["url"])
  end

  def name
    get_present_value(@@game_engine.name, @@igdb_data["name"])
  end

  def slug
    get_present_value(@@game_engine.slug, @@igdb_data["slug"])
  end
end
